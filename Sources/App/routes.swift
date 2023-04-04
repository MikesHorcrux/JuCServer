import Fluent
import Vapor
import OpenAIKit

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("greeting") { req -> EventLoopFuture<String> in
        guard let name = req.query[String.self, at: "name"] else {
            throw Abort(.badRequest)
        }
        let greeting = "Hello, \(name)!"
        return req.eventLoop.makeSucceededFuture(greeting)
    }
    
    // Register the chatRoute function as a collection using the app.routes method
    let apiKey: String = "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"
    let organization: String = "org-iyyujRkCm0DThRIaGIOYipko"
    let openAIManager = OpenAIManager(apiKey: apiKey, organization: organization)
    let chatController = ChatController(openAIManager: openAIManager)
    try app.register(collection: chatController)
    
    //try app.register(collection: TodoController())
}
