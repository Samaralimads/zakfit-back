//
//  Activity.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 27/11/2025.
//

import Fluent
import Vapor

final class Activity: Model, Content, @unchecked Sendable {
    static let schema = "activities"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "date")
    var date: Date

    @Field(key: "duration")
    var duration: Int

    @Field(key: "calories_burned")
    var caloriesBurned: Int

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "activity_type_id")
    var activityType: ActivityType

    init() {}

    init(
        id: UUID? = nil,
        date: Date,
        duration: Int,
        caloriesBurned: Int,
        userID: User.IDValue,
        activityTypeID: ActivityType.IDValue
    ) {
        self.id = id
        self.date = date
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.$user.id = userID
        self.$activityType.id = activityTypeID
    }
}
