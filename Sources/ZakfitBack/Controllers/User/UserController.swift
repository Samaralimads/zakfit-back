//
//  UserController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 30/11/2025.
//

import Vapor
import Fluent
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        users.get(use: getAllUsers)

        let protected = users.grouped(JWTMiddleware())
        protected.get("profile", use: getProfile)
        protected.patch("profile", use: updateProfile)
        protected.delete("profile", use: deleteUser)
    }

    // MARK: - Get all users
    func getAllUsers(req: Request) async throws -> [UserResponseDTO] {
        let users = try await User.query(on: req.db).all()
        return users.map { $0.toResponseDTO() }
    }

    // MARK: - Get current user profile
    func getProfile(req: Request) async throws -> UserResponseDTO {
        let user = try req.auth.require(User.self)
        return user.toResponseDTO()
    }

    // MARK: - Update profile
    func updateProfile(req: Request) async throws -> UserResponseDTO {
        try UpdateUserDTO.validate(content: req)
        let dto = try req.content.decode(UpdateUserDTO.self)

        let user = try req.auth.require(User.self)

        user.firstName = dto.firstName ?? user.firstName
        user.lastName = dto.lastName ?? user.lastName
        user.email = dto.email ?? user.email
        user.age = dto.age ?? user.age
        user.heightCm = dto.heightCm ?? user.heightCm
        user.weightKg = dto.weightKg ?? user.weightKg
        user.gender = dto.gender ?? user.gender
        user.dietaryPreferences = dto.dietaryPreferences ?? user.dietaryPreferences

        if let password = dto.password {
            user.password = try Bcrypt.hash(password)
        }

        try await user.update(on: req.db)
        return user.toResponseDTO()
    }

    // MARK: - Delete profile
    func deleteUser(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        try await user.delete(on: req.db)
        return .noContent
    }
}
