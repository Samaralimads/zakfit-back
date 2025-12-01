//
//  CreateMeal.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 29/11/2025.
//

import Fluent

struct CreateMeal: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Meal.schema)
            .id()
            .field("date", .date, .required)
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("meal_types_id", .uuid, .required, .references(MealType.schema, .id, onDelete: .cascade))
        
            .field("meal_items_id", .array(of: .uuid))
            .field("custom_meal_items_id", .array(of: .uuid))

            .field("total_kcal", .int, .required)
            .field("total_protein", .int, .required)
            .field("total_carbs", .int, .required)
            .field("total_fat", .int, .required)
            .create()
    }
    
    func revert(on db: any Database) async throws {
        try await db.schema(Meal.schema).delete()
    }
}
