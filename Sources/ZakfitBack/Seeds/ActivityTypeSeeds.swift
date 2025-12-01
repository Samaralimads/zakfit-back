//
//  ActivityTypeSeeds.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct ActivityTypeSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await [
            ActivityType(activity: "Yoga"),
            ActivityType(activity: "Strength"),
            ActivityType(activity: "Cardio"),
            ActivityType(activity: "Other"),
        ].create(on: db)
    }
    
    func revert(on db: any Database) async throws {
        try await ActivityType.query(on: db).delete()
    }
}
