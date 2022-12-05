import Foundation
import NIOCore

public enum TodoServiceError: Error {
    case notFound
}

public protocol TodoServiceLogic {

    func fetchAll(on eventLoop: EventLoop) async throws -> [Todo]
    func create(title: String, on eventLoop: EventLoop) async throws -> Todo
    func delete(id: UUID, on eventLoop: EventLoop) async throws
}

public final class TodoService: TodoServiceLogic {

    private let repository: TodoRepositoryLogic

    public init(repository: TodoRepositoryLogic) {
        self.repository = repository
    }

    public func fetchAll(on eventLoop: EventLoop) async throws -> [Todo] {
        try await repository
            .fetchAll(on: eventLoop)
    }

    public func create(title: String, on eventLoop: EventLoop) async throws -> Todo {
        let todo = Todo(id: nil, title: title)
        return try await repository.save(todo: todo, on: eventLoop)
    }

    public func delete(id: UUID, on eventLoop: EventLoop) async throws {
        guard let todo = try await repository.find(id: id, on: eventLoop) else {
            throw TodoServiceError.notFound
        }
        try await repository.delete(todo: todo, on: eventLoop)
    }
}
