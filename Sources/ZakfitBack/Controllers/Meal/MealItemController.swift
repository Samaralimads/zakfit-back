//
//  MealItemController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct MealItemController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let mealItems = routes.grouped("meal-items")

        mealItems.get(use: getAll)
        mealItems.get(":mealItemID", use: getByID)
    }

    func getAll(req: Request) async throws -> [MealItem] {
        try await MealItem.query(on: req.db).all()
    }

    func getByID(req: Request) async throws -> MealItem {
        guard let idString = req.parameters.get("mealItemID"),
              let uuid = UUID(uuidString: idString),
              let item = try await MealItem.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "MealItem not found")
        }
        return item
    }

}

