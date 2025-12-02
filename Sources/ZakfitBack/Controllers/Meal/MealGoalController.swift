//
//  MealGoalController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct MealGoalController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {
        let mealGoals = routes.grouped("meal-goals")
        let protected = mealGoals.grouped(JWTMiddleware())

        protected.post(use: create)
        protected.get(use: getForUser)
        protected.patch(use: update)
        protected.delete(use: delete)
        protected.post("auto", use: autoCalculate)
    }

    // MARK: - Create manual goal
    func create(req: Request) async throws -> MealGoalResponseDTO {
        let user = try req.auth.require(User.self)

        try CreateMealGoalDTO.validate(content: req)
        let dto = try req.content.decode(CreateMealGoalDTO.self)

        let goal = MealGoal(
            userID: try user.requireID(),
            kcalGoal: dto.kcalGoal,
            proteinGoal: dto.proteinGoal,
            carbsGoal: dto.carbsGoal,
            fatGoal: dto.fatGoal
        )

        try await goal.save(on: req.db)
        return goal.toResponseDTO()
    }

    // MARK: - Get goal for authenticated user
    func getForUser(req: Request) async throws -> MealGoalResponseDTO {
        let user = try req.auth.require(User.self)

        guard let goal = try await MealGoal.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .with(\.$user)
            .first()
        else {
            throw Abort(.notFound, reason: "Meal goal not found for this user.")
        }

        return goal.toResponseDTO()
    }

    // MARK: - Update goal
    func update(req: Request) async throws -> MealGoalResponseDTO {
        let user = try req.auth.require(User.self)
        let dto = try req.content.decode(UpdateMealGoalDTO.self)

        guard let goal = try await MealGoal.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .first()
        else {
            throw Abort(.notFound, reason: "Meal goal not found for this user.")
        }

        if let kcal = dto.kcalGoal { goal.kcalGoal = kcal }
        if let protein = dto.proteinGoal { goal.proteinGoal = protein }
        if let carbs = dto.carbsGoal { goal.carbsGoal = carbs }
        if let fat = dto.fatGoal { goal.fatGoal = fat }

        try await goal.save(on: req.db)
        return goal.toResponseDTO()
    }

    // MARK: - Delete goal
    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)

        guard let goal = try await MealGoal.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .first()
        else {
            throw Abort(.notFound, reason: "Meal goal not found for this user.")
        }

        try await goal.delete(on: req.db)
        return .noContent
    }

    // MARK: - Auto calculate (BMR only, using User table data)
    func autoCalculate(req: Request) async throws -> MealGoalResponseDTO {
        let user = try req.auth.require(User.self)
        let userId = try user.requireID()

        // Garantir que o usuário tem todos os dados necessários
        guard
            let weight = user.weightKg,
            let height = user.heightCm,
            let age = user.age,
            let gender = user.gender
        else {
            throw Abort(.badRequest, reason: "User profile is incomplete for BMR calculation.")
        }

        // Calcular BMR
        let bmr = calculateBMR(
            weight: weight,
            height: height,
            age: age,
            sex: gender
        )

        let macros = calculateMacros(from: bmr)

        // Atualizar ou criar MealGoal
        let goal = try await MealGoal.query(on: req.db)
            .filter(\.$user.$id == userId)
            .first() ?? MealGoal(
                userID: userId,
                kcalGoal: 0,
                proteinGoal: 0,
                carbsGoal: 0,
                fatGoal: 0
            )

        goal.kcalGoal = Int(bmr.rounded())
        goal.proteinGoal = macros.protein
        goal.carbsGoal = macros.carbs
        goal.fatGoal = macros.fat

        try await goal.save(on: req.db)
        return goal.toResponseDTO()
    }

    // MARK: - BMR Calculator
    private func calculateBMR(weight: Double, height: Double, age: Int, sex: String) -> Double {
        if sex.lowercased() == "male" {
            return 10 * weight + 6.25 * height - 5 * Double(age) + 5
        } else {
            return 10 * weight + 6.25 * height - 5 * Double(age) - 161
        }
    }

    // MARK: - Macro Distribution (30% protein / 40% carbs / 30% fat)
    private func calculateMacros(from kcal: Double) -> (protein: Int, carbs: Int, fat: Int) {
        let proteinKcal = kcal * 0.30
        let carbsKcal = kcal * 0.40
        let fatKcal = kcal * 0.30

        return (
            protein: Int(proteinKcal / 4),
            carbs: Int(carbsKcal / 4),
            fat: Int(fatKcal / 9)
        )
    }
}
