//
//  UserPayload.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 30/11/2025.
//

import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    var id: UUID
    var expiration: Date
    
    func verify(using signer: JWTSigner) throws {
        guard expiration > Date() else {
            throw Abort(.unauthorized, reason: "Token expired.")
        }
    }
    init(id: UUID) {
        self.id = id
        self.expiration = Date().addingTimeInterval(604800)
    }
}
