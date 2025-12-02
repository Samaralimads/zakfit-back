//
//  CustomMealItemDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor

struct CreateCustomMealItemDTO: Content, Validatable {
    var name: String
    var servingSize: Int
    var servingUnit: String
    var kcalServing: Int
    var proteinServing: Int
    var carbsServing: Int
    var fatServing: Int

    static func validations(_ v: inout Validations) {
        v.add("name", as: String.self, is: .count(1...), required: true)
        v.add("servingSize", as: Int.self, required: true)
        v.add("servingUnit", as: String.self, required: true)
        v.add("kcalServing", as: Int.self, required: true)
        v.add("proteinServing", as: Int.self, required: true)
        v.add("carbsServing", as: Int.self, required: true)
        v.add("fatServing", as: Int.self, required: true)
    }
}

struct CustomMealItemResponseDTO: Content {
    var id: UUID
    var name: String
    var servingSize: Int
    var servingUnit: String
    var kcalServing: Int
    var proteinServing: Int
    var carbsServing: Int
    var fatServing: Int
}

extension CustomMealItem {
    func toResponseDTO() -> CustomMealItemResponseDTO {
        return CustomMealItemResponseDTO(
            id: self.id!,
            name: self.name,
            servingSize: self.servingSize,
            servingUnit: self.servingUnit,
            kcalServing: self.kcalServing,
            proteinServing: self.proteinServing,
            carbsServing: self.carbsServing,
            fatServing: self.fatServing
        )
    }
}
