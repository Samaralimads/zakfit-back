//
//  MealTypeSeeds.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct MealTypeSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await [
            MealType(name: "Breakfast"),
            MealType(name: "Lunch"),
            MealType(name: "Snack"),
            MealType(name: "Dinner")
        ].create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await MealType.query(on: db).delete()
    }
}
