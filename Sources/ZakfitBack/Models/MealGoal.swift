//
//  MealGoal.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 27/11/2025.
//

import Fluent
import Vapor

final class MealGoal: Model, Content, @unchecked Sendable {
    static let schema = "meal_goals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "kcal_goal")
    var kcalGoal: Int
    
    @Field(key: "protein_goal")
    var proteinGoal: Int
    
    @Field(key: "carbs_goal")
    var carbsGoal: Int
    
    @Field(key: "fat_goal")
    var fatGoal: Int
    
    init() {}
    
    init(
        id: UUID? = nil,
        userID: User.IDValue,
        kcalGoal: Int,
        proteinGoal: Int,
        carbsGoal: Int,
        fatGoal: Int
    ) {
        self.id = id
        self.$user.id = userID
        self.kcalGoal = kcalGoal
        self.proteinGoal = proteinGoal
        self.carbsGoal = carbsGoal
        self.fatGoal = fatGoal
    }
}
