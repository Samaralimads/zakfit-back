//
//  CreateMealItem.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 29/11/2025.
//

import Fluent

struct CreateMealItem: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(MealItem.schema)
            .id()
            .field("name", .string, .required)
            .field("serving_size", .int, .required)
            .field("serving_unit", .string, .required)
            .field("kcal_serving", .int, .required)
            .field("protein_serving", .int, .required)
            .field("carbs_serving", .int, .required)
            .field("fat_serving", .int, .required)
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema(MealItem.schema).delete()
    }
}
