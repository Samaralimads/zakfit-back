//
//  AuthController.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 30/11/2025.
//

import Vapor
import Fluent
import JWT

struct AuthController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("register", use: register)
        auth.post("login", use: login)
    }

    // MARK: - Register
    func register(req: Request) async throws -> UserResponseDTO {
        try CreateUserDTO.validate(content: req)
        let dto = try req.content.decode(CreateUserDTO.self)

        if try await User.query(on: req.db)
            .filter(\.$email == dto.email)
            .first() != nil {
            throw Abort(.conflict, reason: "Email already taken.")
        }

        let user = User(
            firstName: dto.firstName,
            lastName: dto.lastName,
            email: dto.email,
            password: try Bcrypt.hash(dto.password)
        )

        try await user.save(on: req.db)
        return user.toResponseDTO()
    }

    // MARK: - Login
    func login(req: Request) async throws -> TokenResponseDTO {
        try LoginDTO.validate(content: req)
        let dto = try req.content.decode(LoginDTO.self)

        guard let user = try await User.query(on: req.db)
                .filter(\.$email == dto.email)
                .first(),
              try Bcrypt.verify(dto.password, created: user.password)
        else {
            throw Abort(.unauthorized, reason: "Invalid email or password.")
        }

        let payload = UserPayload(id: try user.requireID())
        let token = try req.jwt.sign(payload)

        return TokenResponseDTO(token: token, user: user.toResponseDTO())
    }
}
