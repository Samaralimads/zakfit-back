//
//  JWTMiddleware.swift
//  ZakfitBack
//
//  Created by Samara Lima da Silva on 30/11/2025.
//

import Vapor
import JWT

final class JWTMiddleware: Middleware {
    func respond(
        to request: Request,
        chainingTo next: any Responder
    ) -> EventLoopFuture<Response> {

        // 1. Extract Bearer token
        guard let token = request.headers.bearerAuthorization?.token else {
            return request.eventLoop.future(
                error: Abort(.unauthorized, reason: "Missing token.")
            )
        }

        do {
            // 2. Verify JWT using app.jwt.signers (configured in configure.swift)
            let payload = try request.jwt.verify(token, as: UserPayload.self)

            // 3. Load user from DB
            return User.find(payload.id, on: request.db).flatMap { user in
                guard let user = user else {
                    return request.eventLoop.future(
                        error: Abort(.unauthorized, reason: "User no longer exists.")
                    )
                }

                // 4. Authenticate user for the request
                request.auth.login(user)

                return next.respond(to: request)
            }
        } catch {
            return request.eventLoop.future(
                error: Abort(.unauthorized, reason: "Invalid or expired token.")
            )
        }
    }
}

