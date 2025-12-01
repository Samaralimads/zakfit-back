//
//  MealGoalDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor

struct CreateMealGoalDTO: Content, Validatable {
    var userId: UUID
    var kcalGoal: Int
    var proteinGoal: Int
    var carbsGoal: Int
    var fatGoal: Int

    static func validations(_ v: inout Validations) {
        v.add("userId", as: UUID.self, required: true)
        v.add("kcalGoal", as: Int.self, required: true)
        v.add("proteinGoal", as: Int.self, required: true)
        v.add("carbsGoal", as: Int.self, required: true)
        v.add("fatGoal", as: Int.self, required: true)
    }
}

struct MealGoalResponseDTO: Content {
    var id: UUID
    var userId: UUID
    var kcalGoal: Int
    var proteinGoal: Int
    var carbsGoal: Int
    var fatGoal: Int
}

extension MealGoal {
    func toResponseDTO() -> MealGoalResponseDTO {
        return MealGoalResponseDTO(
            id: self.id!,
            userId: self.user.id!,
            kcalGoal: self.kcalGoal,
            proteinGoal: self.proteinGoal,
            carbsGoal: self.carbsGoal,
            fatGoal: self.fatGoal
        )
    }
}
