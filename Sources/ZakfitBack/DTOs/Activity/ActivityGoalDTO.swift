//
//  ActivityGoalDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor

struct CreateActivityGoalDTO: Content, Validatable {
    var userId: UUID
    var activityTypeId: UUID
    var goalType: String
    var amount: Int

    static func validations(_ v: inout Validations) {
        v.add("userId", as: UUID.self, required: true)
        v.add("activityTypeId", as: UUID.self, required: true)
        v.add("goalType", as: String.self, required: true)
        v.add("amount", as: Int.self, required: true)
    }
}

struct ActivityGoalResponseDTO: Content {
    var id: UUID
    var userId: UUID
    var activityTypeId: UUID
    var goalType: String
    var amount: Int
}

extension ActivityGoal {
    func toResponseDTO() -> ActivityGoalResponseDTO {
        return ActivityGoalResponseDTO(
            id: self.id!,
            userId: self.user.id!,
            activityTypeId: self.activityType.id!,
            goalType: self.goalType,
            amount: self.amount
        )
    }
}
