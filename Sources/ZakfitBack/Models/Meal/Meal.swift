//
//  Meal.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 27/11/2025.
//

import Fluent
import Vapor

final class Meal: Model, Content, @unchecked Sendable {
    static let schema = "meals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "date")
    var date: Date
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "meal_types_id")
    var mealType: MealType
    
    @Field(key: "meal_items_id")
    var mealItemIds: [UUID]
    
    @Field(key: "custom_meal_items_id")
    var customMealItemIds: [UUID]
    
    @Field(key: "total_kcal")
    var totalKcal: Int
    
    @Field(key: "total_protein")
    var totalProtein: Int
    
    @Field(key: "total_carbs")
    var totalCarbs: Int
    
    @Field(key: "total_fat")
    var totalFat: Int
    
    init() {}

    init(id: UUID? = nil, userID: UUID, mealTypeID: UUID, date: Date, mealItemIds: [UUID], customMealItemIds: [UUID], totalKcal: Int, totalProtein: Int, totalCarbs: Int, totalFat: Int) {
        self.id = id
        self.$user.id = userID
        self.$mealType.id = mealTypeID
        self.mealItemIds = mealItemIds
        self.customMealItemIds = customMealItemIds
        self.date = date
        self.totalKcal = totalKcal
        self.totalProtein = totalProtein
        self.totalCarbs = totalCarbs
        self.totalFat = totalFat
    }
}
