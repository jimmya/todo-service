import Foundation
import NIOCore

enum TodoServiceError: Error {
    case notFound
}

protocol TodoServiceLogic {

    func fetchAll(on eventLoop: EventLoop) async throws -> [Todo]
    func create(title: String, on eventLoop: EventLoop) async throws -> Todo
    func delete(id: UUID, on eventLoop: EventLoop) async throws
}

final class TodoService: TodoServiceLogic {

    private let repository: TodoRepositoryLogic

    init(repository: TodoRepositoryLogic) {
        self.repository = repository
    }

    func fetchAll(on eventLoop: EventLoop) async throws -> [Todo] {
        try await repository
            .fetchAll(on: eventLoop)
    }

    func create(title: String, on eventLoop: EventLoop) async throws -> Todo {
        let todo = Todo(id: nil, title: title)
        return try await repository.save(todo: todo, on: eventLoop)
    }

    func delete(id: UUID, on eventLoop: EventLoop) async throws {
        guard let todo = try await repository.find(id: id, on: eventLoop) else {
            throw TodoServiceError.notFound
        }
        try await repository.delete(todo: todo, on: eventLoop)
    }
}
