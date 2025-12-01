//
//  CustomMealItemController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct CustomMealItemController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        let customMealItems = routes.grouped("custom-meal-items")
        let protected = customMealItems.grouped(JWTMiddleware())
        
        protected.get(use: getAll)
        protected.get(":customMealItemID", use: getByID)
        protected.post(use: create)
        protected.patch(":customMealItemID", use: update)
        protected.delete(":customMealItemID", use: delete)
    }
    
    // MARK: - Get all custom meal items for the authenticated user
    func getAll(req: Request) async throws -> [CustomMealItemResponseDTO] {
        let user = try req.auth.require(User.self)
        let items = try await CustomMealItem.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .all()
        return items.map { $0.toResponseDTO() }
    }
    
    // MARK: - Get one by ID
    func getByID(req: Request) async throws -> CustomMealItemResponseDTO {
        let user = try req.auth.require(User.self)
        guard let idString = req.parameters.get("customMealItemID"),
              let uuid = UUID(uuidString: idString),
              let item = try await CustomMealItem.query(on: req.db)
                    .filter(\.$user.$id == user.id!)
                    .filter(\.$id == uuid)
                    .first() else {
            throw Abort(.notFound, reason: "CustomMealItem not found or does not belong to the current user")
        }
        return item.toResponseDTO()
    }
    
    // MARK: - Create a custom meal item
    func create(req: Request) async throws -> CustomMealItemResponseDTO {
        try CreateCustomMealItemDTO.validate(content: req)
        let dto = try req.content.decode(CreateCustomMealItemDTO.self)
        let user = try req.auth.require(User.self)
        
        let item = CustomMealItem(
            userID: user.id!,
            name: dto.name,
            servingSize: dto.servingSize,
            servingUnit: dto.servingUnit,
            kcalServing: dto.kcalServing,
            proteinServing: dto.proteinServing,
            carbsServing: dto.carbsServing,
            fatServing: dto.fatServing
        )
        
        try await item.save(on: req.db)
        return item.toResponseDTO()
    }
    
    // MARK: - Update item
    func update(req: Request) async throws -> CustomMealItemResponseDTO {
        try CreateCustomMealItemDTO.validate(content: req)
        let dto = try req.content.decode(CreateCustomMealItemDTO.self)
        let user = try req.auth.require(User.self)
        
        guard let idString = req.parameters.get("customMealItemID"),
              let uuid = UUID(uuidString: idString),
              let existing = try await CustomMealItem.query(on: req.db)
                    .filter(\.$user.$id == user.id!)
                    .filter(\.$id == uuid)
                    .first() else {
            throw Abort(.notFound, reason: "CustomMealItem not found or does not belong to the current user")
        }
        
        existing.name = dto.name
        existing.servingSize = dto.servingSize
        existing.servingUnit = dto.servingUnit
        existing.kcalServing = dto.kcalServing
        existing.proteinServing = dto.proteinServing
        existing.carbsServing = dto.carbsServing
        existing.fatServing = dto.fatServing
        
        try await existing.update(on: req.db)
        return existing.toResponseDTO()
    }
    
    // MARK: - Delete item
    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        guard let idString = req.parameters.get("customMealItemID"),
              let uuid = UUID(uuidString: idString),
              let item = try await CustomMealItem.query(on: req.db)
                    .filter(\.$user.$id == user.id!)
                    .filter(\.$id == uuid)
                    .first() else {
            throw Abort(.notFound, reason: "CustomMealItem not found or does not belong to the current user")
        }
        try await item.delete(on: req.db)
        return .noContent
    }
}
