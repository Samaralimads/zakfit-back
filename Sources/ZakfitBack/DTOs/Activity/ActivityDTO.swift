//
//  ActivityDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor

struct CreateActivityDTO: Content, Validatable {
    var date: Date
    var duration: Int
    var caloriesBurned: Int?
    var activityTypeId: UUID

    static func validations(_ v: inout Validations) {
        v.add("activityTypeId", as: UUID.self, required: true)
        v.add("duration", as: Int.self, required: true)
    }
}

struct ActivityResponseDTO: Content {
    var id: UUID
    var date: Date
    var duration: Int
    var caloriesBurned: Int
    var activityTypeId: UUID
    var activityTypeName: String
    var userId: UUID
}

extension Activity {
    func toResponseDTO() -> ActivityResponseDTO {
        return ActivityResponseDTO(
            id: self.id!,
            date: self.date,
            duration: self.duration,
            caloriesBurned: self.caloriesBurned,
            activityTypeId: self.$activityType.id,
            activityTypeName: self.activityType.activity,
            userId: self.$user.id
        )
    }
}

