//
//  MealTypeDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor

struct CreateMealTypeDTO: Content, Validatable {
    var name: String

    static func validations(_ v: inout Validations) {
        v.add("name", as: String.self, is: .count(1...), required: true)
    }
}

struct MealTypeResponseDTO: Content {
    var id: UUID
    var name: String
}

extension MealType {
    func toResponseDTO() -> MealTypeResponseDTO {
        MealTypeResponseDTO(
            id: self.id!,
            name: self.name!
        )
    }
}

