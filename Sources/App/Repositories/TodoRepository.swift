import Vapor
import Fluent

protocol TodoRepositoryLogic {

    func fetchAll(on eventLoop: EventLoop) async throws -> [Todo]
    func save(todo: Todo, on eventLoop: EventLoop) async throws -> Todo
    func find(id: UUID, on eventLoop: EventLoop) async throws -> Todo?
    func delete(todo: Todo, on eventLoop: EventLoop) async throws
}

final class TodoRepository: TodoRepositoryLogic {

    private let application: Application

    init(application: Application) {
        self.application = application
    }

    func fetchAll(on eventLoop: EventLoop) async throws -> [Todo] {
        let db = application.db(on: eventLoop)
        return try await TodoEntity.query(on: db).all().map { Todo(id: $0.id, title: $0.title) }
    }

    func save(todo: Todo, on eventLoop: EventLoop) async throws -> Todo {
        let db = application.db(on: eventLoop)
        let entity = TodoEntity(todo: todo)
        try await entity.save(on: db)
        return entity.todo
    }

    func find(id: UUID, on eventLoop: EventLoop) async throws -> Todo? {
        let db = application.db(on: eventLoop)
        return try await TodoEntity.find(id, on: db)?.todo
    }

    func delete(todo: Todo, on eventLoop: EventLoop) async throws {
        let db = application.db(on: eventLoop)
        let entity = TodoEntity(todo: todo)
        try await entity.delete(on: db)
    }
}
