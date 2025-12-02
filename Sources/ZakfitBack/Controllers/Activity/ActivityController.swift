//
//  ActivityController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor
import Fluent

struct ActivityController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let activity = routes.grouped("activities")
        let protected = activity.grouped(JWTMiddleware())

        protected.post(use: create)
        protected.get(use: getAll)
        protected.get(":activityId", use: getById)
        protected.patch(":activityId", use: update)
        protected.delete(":activityId", use: delete)
    }

    // MARK: - Calorie calculator
      private func calculateCalories(typeName: String, duration: Int) -> Int {
           switch typeName.lowercased() {
           case "yoga":
               return Int(3.0 * Double(duration))
           case "strength":
               return Int(6.0 * Double(duration))
           case "cardio":
               return Int(8.0 * Double(duration))
           default:
               return Int(4.0 * Double(duration))
           }
       }

    // MARK: - Create activity
     func create(req: Request) async throws -> ActivityResponseDTO {
         let user = try req.auth.require(User.self)
         try CreateActivityDTO.validate(content: req)
         let dto = try req.content.decode(CreateActivityDTO.self)
         
         guard let activityType = try await ActivityType.find(dto.activityTypeId, on: req.db) else {
             throw Abort(.notFound, reason: "Activity type not found")
         }
         
         let calories = dto.caloriesBurned ?? calculateCalories(typeName: activityType.activity, duration: dto.duration)
         
         let activity = Activity(
             date: dto.date,
             duration: dto.duration,
             caloriesBurned: calories,
             userID: try user.requireID(),
             activityTypeID: try activityType.requireID()
         )
         
         try await activity.save(on: req.db)
         try await activity.$activityType.load(on: req.db)
         try await activity.$user.load(on: req.db)
         return activity.toResponseDTO()
     }
     
     // MARK: - Get all activities for user
     func getAll(req: Request) async throws -> [ActivityResponseDTO] {
         let user = try req.auth.require(User.self)
         let userId = try user.requireID()
         
         let activities = try await Activity.query(on: req.db)
             .filter(\.$user.$id == userId)
             .with(\.$activityType)
             .with(\.$user)
             .all()
         
         return activities.map { $0.toResponseDTO() }
     }
     
     // MARK: - Get one activity by ID
     func getById(req: Request) async throws -> ActivityResponseDTO {
         let user = try req.auth.require(User.self)
         let userId = try user.requireID()
         guard let activityID = req.parameters.get("activityID", as: UUID.self) else {
             throw Abort(.badRequest, reason: "Invalid or missing activity ID")
         }
         
         guard let activity = try await Activity.query(on: req.db)
             .filter(\.$id == activityID)
             .filter(\.$user.$id == userId)
             .with(\.$activityType)
             .first()
         else {
             throw Abort(.notFound, reason: "Activity not found for this user")
         }
         
         return activity.toResponseDTO()
     }
     
     // MARK: - Update activity
     func update(req: Request) async throws -> ActivityResponseDTO {
         let user = try req.auth.require(User.self)
         let userId = try user.requireID()
         guard let activityID = req.parameters.get("activityID", as: UUID.self) else {
             throw Abort(.badRequest, reason: "Invalid or missing activity ID")
         }
         
         let dto = try req.content.decode(CreateActivityDTO.self)
         
         guard let activity = try await Activity.query(on: req.db)
             .filter(\.$id == activityID)
             .filter(\.$user.$id == userId)
             .first()
         else {
             throw Abort(.notFound, reason: "Activity not found for this user")
         }
         
         if let calories = dto.caloriesBurned {
             activity.caloriesBurned = calories
         } else if let type = try await ActivityType.find(dto.activityTypeId, on: req.db) {
             activity.caloriesBurned = calculateCalories(typeName: type.activity, duration: dto.duration)
         }
         
         activity.date = dto.date
         activity.duration = dto.duration
         activity.$activityType.id = dto.activityTypeId
         
         try await activity.save(on: req.db)
         try await activity.$activityType.load(on: req.db)
         try await activity.$user.load(on: req.db)
         return activity.toResponseDTO()
     }
     
     // MARK: - Delete activity
     func delete(req: Request) async throws -> HTTPStatus {
         let user = try req.auth.require(User.self)
         let userId = try user.requireID()
         guard let activityID = req.parameters.get("activityID", as: UUID.self) else {
             throw Abort(.badRequest, reason: "Invalid or missing activity ID")
         }
         
         guard let activity = try await Activity.query(on: req.db)
             .filter(\.$id == activityID)
             .filter(\.$user.$id == userId)
             .first()
         else {
             throw Abort(.notFound, reason: "Activity not found for this user")
         }
         
         try await activity.delete(on: req.db)
         return .noContent
     }
 }
