//
//  MealDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor

import Vapor

struct CreateMealDTO: Content, Validatable {
    var date: Date
    var mealTypeId: UUID
    var mealItemIds: [UUID]
    var customMealItemIds: [UUID]
    var totalKcal: Int
    var totalProtein: Int
    var totalCarbs: Int
    var totalFat: Int
    
    static func validations(_ v: inout Validations) {
        v.add("mealTypeId", as: UUID.self, required: true)
        v.add("mealItemIds", as: [UUID].self)
        v.add("customMealItemIds", as: [UUID].self)
        v.add("totalKcal", as: Int.self, required: true)
        v.add("totalProtein", as: Int.self, required: true)
        v.add("totalCarbs", as: Int.self, required: true)
        v.add("totalFat", as: Int.self, required: true)
    }

    func validate() throws {
        guard !mealItemIds.isEmpty || !customMealItemIds.isEmpty else {
            throw Abort(.badRequest, reason: "A meal must have at least one MealItem or CustomMealItem.")
        }
    }
}

struct MealResponseDTO: Content {
    var id: UUID
    var date: Date
    var userId: UUID
    var mealTypeId: UUID
    var mealItemIds: [UUID]
    var customMealItemIds: [UUID]
    var totalKcal: Int
    var totalProtein: Int
    var totalCarbs: Int
    var totalFat: Int
}

extension Meal {
    func toResponseDTO() -> MealResponseDTO {
        return MealResponseDTO(
            id: self.id!,
            date: self.date,
            userId: self.$user.id,
            mealTypeId: self.$mealType.id,
            mealItemIds: self.mealItemIds,
            customMealItemIds: self.customMealItemIds,
            totalKcal: self.totalKcal,
            totalProtein: self.totalProtein,
            totalCarbs: self.totalCarbs,
            totalFat: self.totalFat
        )
    }
}








