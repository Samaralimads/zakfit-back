//
//  CreateMealGoal.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 29/11/2025.
//

import Fluent

struct CreateMealGoal: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(MealGoal.schema)
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("kcal_goal", .int, .required)
            .field("protein_goal", .int, .required)
            .field("carbs_goal", .int, .required)
            .field("fat_goal", .int, .required)
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema(MealGoal.schema).delete()
    }
}
