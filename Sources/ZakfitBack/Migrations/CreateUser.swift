//
//  CreateUser.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 29/11/2025.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(User.schema)
            .id()
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("email", .string, .required)
            .unique(on: "email")
            .field("password", .string, .required)
            .field("age", .int)
            .field("height_cm", .double)
            .field("weight_kg", .double)
            .field("gender", .string)
            .field("dietary_preferences", .string)            .create()
    }
    
    func revert(on db: any Database) async throws {
        try await db.schema(User.schema).delete()
    }
}

