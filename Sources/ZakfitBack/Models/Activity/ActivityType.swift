//
//  ActivityType.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 27/11/2025.
//

import Fluent
import Vapor

final class ActivityType: Model, Content, @unchecked Sendable {
    static let schema = "activity_types"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "activity")
    var activity: String
    
    @Children(for: \.$activityType)
    var activities: [Activity]

    @Children(for: \.$activityType)
    var activityGoals: [ActivityGoal]

    init() {}

    init(id: UUID? = nil, activity: String) {
        self.id = id
        self.activity = activity
    }
}
