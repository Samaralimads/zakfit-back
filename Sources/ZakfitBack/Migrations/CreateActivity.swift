//
//  CreateActivity.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 29/11/2025.
//

import Fluent

struct CreateActivity: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(Activity.schema)
            .id()
            .field("date", .date, .required)
            .field("duration", .int, .required)
            .field("calories_burned", .int, .required)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("activity_type_id", .uuid, .required, .references("activity_types", "id", onDelete: .cascade))
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema(Activity.schema).delete()
    }
}
