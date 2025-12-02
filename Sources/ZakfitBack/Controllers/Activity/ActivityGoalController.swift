//
//  ActivityGoalController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct ActivityGoalController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        let activityGoals = routes.grouped("activity-goals")
        let protected = activityGoals.grouped(JWTMiddleware())
        
        protected.post(use: create)
        protected.get(use: getForUser)
        protected.get(":goalID", use: getById)
        protected.patch(":goalID", use: update)
        protected.delete(":goalID", use: delete)
    }
    
    // MARK: - Create activity goal
    func create(req: Request) async throws -> ActivityGoalResponseDTO {
        let user = try req.auth.require(User.self)
        
        try CreateActivityGoalDTO.validate(content: req)
        let dto = try req.content.decode(CreateActivityGoalDTO.self)
        
        let goal = ActivityGoal(
            userID: try user.requireID(),
            activityTypeID: dto.activityTypeId,
            goalType: dto.goalType,
            amount: dto.amount
        )
        
        try await goal.save(on: req.db)
        try await goal.$activityType.load(on: req.db)
        return goal.toResponseDTO()
    }
    
    // MARK: - Get all activity goals for user
    func getForUser(req: Request) async throws -> [ActivityGoalResponseDTO] {
        let user = try req.auth.require(User.self)
        
        let goals = try await ActivityGoal.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .with(\.$activityType)
            .with(\.$user)
            .all()
        
        return goals.map { $0.toResponseDTO() }
    }
    
    // MARK: - Get one by ID
    func getById(req: Request) async throws -> ActivityGoalResponseDTO {
        let user = try req.auth.require(User.self)
        guard let goalID = req.parameters.get("goalID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing goal ID")
        }
        
        guard let goal = try await ActivityGoal.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$id == goalID)
            .with(\.$activityType)
            .with(\.$user)
            .first()
        else {
            throw Abort(.notFound, reason: "Activity goal not found for this user")
        }
        
        return goal.toResponseDTO()
    }
    
    // MARK: - Update activity goal
    func update(req: Request) async throws -> ActivityGoalResponseDTO {
        let user = try req.auth.require(User.self)
        guard let goalID = req.parameters.get("goalID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing goal ID")
        }
        
        let dto = try req.content.decode(CreateActivityGoalDTO.self)
        
        guard let goal = try await ActivityGoal.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$id == goalID)
            .first()
        else {
            throw Abort(.notFound, reason: "Activity goal not found for this user")
        }
        
        goal.$activityType.id = dto.activityTypeId
        goal.goalType = dto.goalType
        goal.amount = dto.amount
        
        try await goal.save(on: req.db)
        try await goal.$activityType.load(on: req.db)
        return goal.toResponseDTO()
    }
    
    // MARK: - Delete activity goal
    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        guard let goalID = req.parameters.get("goalID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing goal ID")
        }
        
        guard let goal = try await ActivityGoal.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$id == goalID)
            .first()
        else {
            throw Abort(.notFound, reason: "Activity goal not found for this user")
        }
        
        try await goal.delete(on: req.db)
        return .noContent
    }
}
