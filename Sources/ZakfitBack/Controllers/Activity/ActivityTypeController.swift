//
//  ActivityTypeController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct ActivityTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let activityTypes = routes.grouped("activity-types")

        activityTypes.get(use: getAll)
        activityTypes.get(":activityTypeID", use: getByID)
    }

    func getAll(req: Request) async throws -> [ActivityTypeResponseDTO] {
        let activityTypes = try await ActivityType.query(on: req.db).all()
        return activityTypes.map { $0.toResponseDTO() }
    }

    func getByID(req: Request) async throws -> ActivityTypeResponseDTO {
        guard let idString = req.parameters.get("activityTypeID"),
              let uuid = UUID(uuidString: idString),
              let activityType = try await ActivityType.find(uuid, on: req.db) else {
            throw Abort(.notFound, reason: "ActivityType not found")
        }
        return activityType.toResponseDTO()
    }
}
