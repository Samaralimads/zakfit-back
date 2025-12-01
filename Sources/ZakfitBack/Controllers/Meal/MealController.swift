//
//  MealController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct MealController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        let meals = routes.grouped("meals")
        let protected = meals.grouped(JWTMiddleware())
        
        protected.get(use: getAllMeals)
        protected.post(use: createMeal)
        protected.get(":mealID", use: getMealById)
        protected.patch(":mealID", use: updateMeal)
        protected.delete(":mealID", use: deleteMeal)
    }

    // MARK: - Get all meals for the authenticated user
    func getAllMeals(req: Request) async throws -> [MealResponseDTO] {
        let user = try req.auth.require(User.self)
        
        let meals = try await Meal.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .with(\.$mealType)
            .with(\.$user)
            .all()

        return meals.map { $0.toResponseDTO() }
    }

    // MARK: - Create a new meal
    func createMeal(req: Request) async throws -> MealResponseDTO {
        try CreateMealDTO.validate(content: req)
        let dto = try req.content.decode(CreateMealDTO.self)
        try dto.validate()

        let user = try req.auth.require(User.self)

        let meal = Meal(
            userID: user.id!,
            mealTypeID: dto.mealTypeId,
            date: dto.date,
            mealItemIds: dto.mealItemIds,
            customMealItemIds: dto.customMealItemIds,
            totalKcal: dto.totalKcal,
            totalProtein: dto.totalProtein,
            totalCarbs: dto.totalCarbs,
            totalFat: dto.totalFat
        )
        
        try await meal.save(on: req.db)
        return meal.toResponseDTO()
    }

    // MARK: - Get specific meal
    func getMealById(req: Request) async throws -> MealResponseDTO {
        let user = try req.auth.require(User.self)

        guard let id = req.parameters.get("mealID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing Meal ID")
        }

        guard let meal = try await Meal.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$id == id)
            .with(\.$mealType)
            .with(\.$user)
            .first()
        else {
            throw Abort(.notFound, reason: "Meal not found or does not belong to the current user")
        }

        return meal.toResponseDTO()
    }

    // MARK: - Update meal
    func updateMeal(req: Request) async throws -> MealResponseDTO {
        let dto = try req.content.decode(CreateMealDTO.self)
        try dto.validate()
        
        let user = try req.auth.require(User.self)

        guard let id = req.parameters.get("mealID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid Meal ID")
        }
        
        guard let meal = try await Meal.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$id == id)
            .first()
        else {
            throw Abort(.notFound, reason: "Meal not found or does not belong to the current user")
        }

        meal.date = dto.date
        meal.$mealType.id = dto.mealTypeId
        meal.mealItemIds = dto.mealItemIds
        meal.customMealItemIds = dto.customMealItemIds
        meal.totalKcal = dto.totalKcal
        meal.totalProtein = dto.totalProtein
        meal.totalCarbs = dto.totalCarbs
        meal.totalFat = dto.totalFat

        try await meal.update(on: req.db)
        return meal.toResponseDTO()
    }

    // MARK: - Delete meal
    func deleteMeal(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)

        guard let id = req.parameters.get("mealID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid Meal ID")
        }
        
        guard let meal = try await Meal.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$id == id)
            .first()
        else {
            throw Abort(.notFound, reason: "Meal not found or does not belong to the current user")
        }

        try await meal.delete(on: req.db)
        return .noContent
    }
}
