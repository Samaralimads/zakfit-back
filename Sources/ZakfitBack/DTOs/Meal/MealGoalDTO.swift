//
//  MealGoalDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor

struct CreateMealGoalDTO: Content, Validatable {
    var kcalGoal: Int
    var proteinGoal: Int
    var carbsGoal: Int
    var fatGoal: Int

    static func validations(_ v: inout Validations) {
        v.add("kcalGoal", as: Int.self, required: true)
        v.add("proteinGoal", as: Int.self, required: true)
        v.add("carbsGoal", as: Int.self, required: true)
        v.add("fatGoal", as: Int.self, required: true)
    }
}

struct UpdateMealGoalDTO: Content {
    var kcalGoal: Int?
    var proteinGoal: Int?
    var carbsGoal: Int?
    var fatGoal: Int?
}

struct MealGoalResponseDTO: Content {
    var id: UUID
    var userId: UUID
    var kcalGoal: Int
    var proteinGoal: Int
    var carbsGoal: Int
    var fatGoal: Int
}

struct AutoCalculateGoalDTO: Content, Validatable {
    var weight: Double
    var height: Double
    var age: Int
    var sex: String

    static func validations(_ v: inout Validations) {
        v.add("weight", as: Double.self, required: true)
        v.add("height", as: Double.self, required: true)
        v.add("age", as: Int.self, required: true)
        v.add("sex", as: String.self, is: .in("male", "female"), required: true)
    }
}


extension MealGoal {
    func toResponseDTO() -> MealGoalResponseDTO {
        return MealGoalResponseDTO(
            id: self.id!,
            userId: self.$user.id,
            kcalGoal: self.kcalGoal,
            proteinGoal: self.proteinGoal,
            carbsGoal: self.carbsGoal,
            fatGoal: self.fatGoal
        )
    }
}
