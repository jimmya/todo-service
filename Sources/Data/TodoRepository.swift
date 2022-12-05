import Vapor
import Fluent
import Domain

public final class TodoRepository: TodoRepositoryLogic {

    private let application: Application

    public init(application: Application) {
        self.application = application
    }

    public func fetchAll(on eventLoop: EventLoop) async throws -> [Todo] {
        let db = application.db(on: eventLoop)
        return try await TodoEntity.query(on: db).all().map { Todo(id: $0.id, title: $0.title) }
    }

    public func save(todo: Todo, on eventLoop: EventLoop) async throws -> Todo {
        let db = application.db(on: eventLoop)
        let entity = TodoEntity(todo: todo)
        try await entity.save(on: db)
        return entity.todo
    }

    public func find(id: UUID, on eventLoop: EventLoop) async throws -> Todo? {
        let db = application.db(on: eventLoop)
        return try await TodoEntity.find(id, on: db)?.todo
    }

    public func delete(todo: Todo, on eventLoop: EventLoop) async throws {
        let db = application.db(on: eventLoop)
        let entity = TodoEntity(todo: todo)
        try await entity.delete(on: db)
    }
}
