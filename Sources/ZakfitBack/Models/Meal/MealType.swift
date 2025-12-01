//
//  MealType.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 27/11/2025.
//

import Fluent
import Vapor

final class MealType: Model, Content, @unchecked Sendable {
    static let schema = "meal_types"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String?
    
    @Children(for: \.$mealType)
     var meals: [Meal]

    init() {}

    init(id: UUID? = nil, name: String?) {
        self.id = id
        self.name = name
    }
}
