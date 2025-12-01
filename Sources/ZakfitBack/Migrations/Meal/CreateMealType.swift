//
//  CreateMealType.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 29/11/2025.
//

import Fluent

struct CreateMealType: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(MealType.schema)
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema(MealType.schema).delete()
    }
}
