//
//  CreateActivityGoal.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 29/11/2025.
//

import Fluent

struct CreateActivityGoal: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(ActivityGoal.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("activity_type_id", .uuid, .required, .references(ActivityType.schema, .id, onDelete: .cascade))
            .field("goal_type", .string, .required)
            .field("amount", .double, .required)
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema(ActivityGoal.schema).delete()
    }
}
