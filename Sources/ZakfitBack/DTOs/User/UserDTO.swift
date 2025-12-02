//
//  UserDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 30/11/2025.
//

import Vapor

struct CreateUserDTO: Content, Validatable {
    var firstName: String
    var lastName: String
    var email: String
    var password: String

    static func validations(_ v: inout Validations) {
        v.add("firstName", as: String.self, is: .count(1...), required: true)
        v.add("lastName", as: String.self, is: .count(1...), required: true)
        v.add("email", as: String.self, is: .email, required: true)
        v.add("password", as: String.self, is: .count(8...), required: true)
    }
}

struct LoginDTO: Content, Validatable {
    var email: String
    var password: String

    static func validations(_ v: inout Validations) {
        v.add("email", as: String.self, is: .email, required: true)
        v.add("password", as: String.self, is: .count(1...), required: true)
    }
}

struct UpdateUserDTO: Content, Validatable {
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var age: Int?
    var heightCm: Double?
    var weightKg: Double?
    var gender: String?
    var dietaryPreferences: String?

    static func validations(_ v: inout Validations) {
        v.add("email", as: String.self, is: .email, required: false)
        v.add("password", as: String.self, is: .count(8...), required: false)
    }
}

struct UserResponseDTO: Content {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var age: Int?
    var heightCm: Double?
    var weightKg: Double?
    var gender: String?
    var dietaryPreferences: String?
}

struct TokenResponseDTO: Content {
    var token: String
    var user: UserResponseDTO
}

extension User {
    func toResponseDTO() -> UserResponseDTO {
        UserResponseDTO(
            id: self.id!,
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email,
            age: self.age,
            heightCm: self.heightCm,
            weightKg: self.weightKg,
            gender: self.gender,
            dietaryPreferences: self.dietaryPreferences
        )
    }
}



