import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    let repository = TodoRepository(application: app)
    let service = TodoService(repository: repository)
    try app.register(collection: TodoController(service: service))
}
