//
//  CustomMealItem.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 27/11/2025.
//

import Fluent
import Vapor

final class CustomMealItem: Model, Content, @unchecked Sendable {
    static let schema = "custom_meal_items"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "name")
    var name: String

    @Field(key: "serving_size")
    var servingSize: Int

    @Field(key: "serving_unit")
    var servingUnit: String

    @Field(key: "kcal_serving")
    var kcalServing: Int

    @Field(key: "protein_serving")
    var proteinServing: Int

    @Field(key: "carbs_serving")
    var carbsServing: Int

    @Field(key: "fat_serving")
    var fatServing: Int

    init() {}

    init(
        id: UUID? = nil,
        userID: User.IDValue,
        name: String,
        servingSize: Int,
        servingUnit: String,
        kcalServing: Int,
        proteinServing: Int,
        carbsServing: Int,
        fatServing: Int
    ) {
        self.id = id
        self.$user.id = userID
        self.name = name
        self.servingSize = servingSize
        self.servingUnit = servingUnit
        self.kcalServing = kcalServing
        self.proteinServing = proteinServing
        self.carbsServing = carbsServing
        self.fatServing = fatServing
    }
}
