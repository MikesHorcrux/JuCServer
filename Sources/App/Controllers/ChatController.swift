//
//  ChatController.swift
//  
//
//  Created by Mike on 4/2/23.
//

import Vapor
import OpenAIKit

struct ChatController: RouteCollection {
    let openAIManager: OpenAIManager
    
    init(openAIManager: OpenAIManager) {
        self.openAIManager = openAIManager
    }
    
    func boot(routes: RoutesBuilder) throws {
        let chats = routes.grouped("api", "v1", "chats")
        chats.post(use: startChat)
    }
    
    func startChat(req: Request) async throws -> ChatResponse {
        let chatRequest = try req.content.decode(ChatRequest.self)
        let message = try await openAIManager.startChat(msg: chatRequest.messages)
        guard let chatMessage = message else {
            throw Abort(.internalServerError)
        }
        return ChatResponse(messages: [chatMessage])
    }
}

struct ChatRequest: Content {
    let messages: [Chat.Message]
}

struct ChatResponse: Content {
    let messages: [Chat.Message]
}
