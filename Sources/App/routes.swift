
import Vapor
import FirebaseJWTMiddleware

func routes(_ app: Application) throws {
    app.firebaseJwt.applicationIdentifier = "juc-just-you-but-corp"
    let apiKey: String = "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"
    let organization: String = "org-iyyujRkCm0DThRIaGIOYipko"
    let openAIManager = OpenAIManager(apiKey: apiKey, organization: organization)
    let chatController = ChatController(openAIManager: openAIManager)
    
    let firebaseMiddleware = FirebaseJWTMiddleware()
    let protectedRoutes = app.routes.grouped(firebaseMiddleware)
    
    protectedRoutes.get("welcome") { req in
        return "Hello, world!"
    }
    try protectedRoutes.register(collection: chatController)
}
