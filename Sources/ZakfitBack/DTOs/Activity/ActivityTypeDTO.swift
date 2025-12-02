//
//  ActivityTypeDTO.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 01/12/2025.
//

import Vapor

struct CreateActivityTypeDTO: Content, Validatable {
    var activity: String

    static func validations(_ v: inout Validations) {
        v.add("activity", as: String.self, required: true)
    }
}

struct ActivityTypeResponseDTO: Content {
    var id: UUID
    var activity: String
}

extension ActivityType {
    func toResponseDTO() -> ActivityTypeResponseDTO {
        return ActivityTypeResponseDTO(
            id: self.id!,
            activity: self.activity
        )
    }
}
