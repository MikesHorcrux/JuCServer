
import Vapor
import FirebaseJWTMiddleware

func routes(_ app: Application) throws {
    app.firebaseJwt.applicationIdentifier = firebase application
    let apiKey: String = openai key
    let organization: String = Openai org
    let openAIManager = OpenAIManager(apiKey: apiKey, organization: organization)
    let chatController = ChatController(openAIManager: openAIManager)
    
    let firebaseMiddleware = FirebaseJWTMiddleware()
    let protectedRoutes = app.routes.grouped(firebaseMiddleware)
    
    protectedRoutes.get("welcome") { req in
        return "Hello, world!"
    }
    try protectedRoutes.register(collection: chatController)
}
