import Vapor

public protocol TodoRepositoryLogic {

    func fetchAll(on eventLoop: EventLoop) async throws -> [Todo]
    func save(todo: Todo, on eventLoop: EventLoop) async throws -> Todo
    func find(id: UUID, on eventLoop: EventLoop) async throws -> Todo?
    func delete(todo: Todo, on eventLoop: EventLoop) async throws
}
