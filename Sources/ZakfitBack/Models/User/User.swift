//
//  User.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 27/11/2025.
//

import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable, Authenticatable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "first_name")
    var firstName: String

    @Field(key: "last_name")
    var lastName: String

    @Field(key: "email")
    var email: String

    @Field(key: "password")
    var password: String

    @Field(key: "age")
    var age: Int?

    @Field(key: "height_cm")
    var heightCm: Double?

    @Field(key: "weight_kg")
    var weightKg: Double?

    @Field(key: "gender")
    var gender: String?

    @Field(key: "dietary_preferences")
    var dietaryPreferences: String?
    
    //MARK: - Relationships
    @Children(for: \.$user)
    var activities: [Activity]

    @Children(for: \.$user)
    var meals: [Meal]

    @Children(for: \.$user)
    var customMealItems: [CustomMealItem]

    @Children(for: \.$user)
    var mealGoals: [MealGoal]

    @Children(for: \.$user)
    var activityGoals: [ActivityGoal]

    init() {}

    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        age: Int? = nil,
        heightCm: Double? = nil,
        weightKg: Double? = nil,
        gender: String? = nil,
        dietaryPreferences: String? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.age = age
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.gender = gender
        self.dietaryPreferences = dietaryPreferences
    }
}



