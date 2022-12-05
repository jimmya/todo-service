import Fluent
import FluentPostgresDriver
import Vapor
import Data
import Domain
import Presentation

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    app.migrations.add(CreateTodo())

    app.todoController = TodoController(service: TodoService(repository: TodoRepository(application: app)))

    // register routes
    try routes(app)
}

struct TodoControllerKey: StorageKey {
    typealias Value = TodoController
}

extension Application {
    var todoController: TodoController {
        get {
            guard let controller = self.storage[TodoControllerKey.self] else {
                fatalError("TodoService not set")
            }
            return controller
        }
        set {
            self.storage[TodoControllerKey.self] = newValue
        }
    }
}
