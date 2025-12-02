//
//  CreateActivityType.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 29/11/2025.
//

import Fluent

struct CreateActivityType: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(ActivityType.schema)
            .id()
            .field("activity", .string, .required)
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema(ActivityType.schema).delete()
    }
}
