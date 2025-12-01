//
//  ActivityGoal.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 27/11/2025.
//

import Fluent
import Vapor

final class ActivityGoal: Model, Content, @unchecked Sendable {
    static let schema = "activity_goals"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "activity_type_id")
    var activityType: ActivityType
    
    @Field(key: "goal_type")
    var goalType: String
    
    @Field(key: "amount")
    var amount: Int
    
    init() {}
    
    init(
        id: UUID? = nil,
        userID: User.IDValue,
        activityTypeID: ActivityType.IDValue,
        goalType: String,
        amount: Int
    ) {
        self.id = id
        self.$user.id = userID
        self.$activityType.id = activityTypeID
        self.goalType = goalType
        self.amount = amount
    }
}
