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
    
    @Parent(key: "meal_type_id")
    var mealType: MealType
    
    @OptionalParent(key: "meal_item_id")
    var mealItems: MealItem?
    
    @OptionalParent(key: "custom_meal_item_id")
    var customMealItems: CustomMealItem?
    
    @Field(key: "total_kcal")
    var totalKcal: Int
    
    @Field(key: "total_protein")
    var totalProtein: Int
    
    @Field(key: "total_carbs")
    var totalCarbs: Int
    
    @Field(key: "total_fat")
    var totalFat: Int
    
    init() {}
    
    init(
        id: UUID? = nil,
        date: Date,
        userID: User.IDValue,
        mealTypeID: MealType.IDValue,
        mealItemsID: MealItem.IDValue? = nil,
        customMealItemsID: CustomMealItem.IDValue? = nil,
        totalKcal: Int,
        totalProtein: Int,
        totalCarbs: Int,
        totalFat: Int
    ) {
        self.id = id
        self.date = date
        self.$user.id = userID
        self.$mealType.id = mealTypeID
        self.$mealItems.id = mealItemsID
        self.$customMealItems.id = customMealItemsID
        self.totalKcal = totalKcal
        self.totalProtein = totalProtein
        self.totalCarbs = totalCarbs
        self.totalFat = totalFat
    }
}
