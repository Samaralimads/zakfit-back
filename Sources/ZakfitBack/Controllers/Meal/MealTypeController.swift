//
//  MealTypeController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct MealTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let mealTypes = routes.grouped("meal-types")

        mealTypes.get(use: getAll)
        mealTypes.get(":mealTypeID", use: getByID)
    }

    func getAll(req: Request) async throws -> [MealTypeResponseDTO] {
        let mealTypes = try await MealType.query(on: req.db).all()
        return mealTypes.map { $0.toResponseDTO() }
    }

    func getByID(req: Request) async throws -> MealTypeResponseDTO {
        guard let idString = req.parameters.get("mealTypeID"),
              let uuid = UUID(uuidString: idString),
              let mealType = try await MealType.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "MealType not found")
        }
        return mealType.toResponseDTO()
    }
}

