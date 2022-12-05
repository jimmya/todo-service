@testable import App
import Vapor
import Domain

final class MockTodoService: TodoServiceLogic {

    var invokedFetchAllCount = 0
    var stubbedFetchAllResult: [Todo] = []
    func fetchAll(on eventLoop: EventLoop) async throws -> [Todo] {
        invokedFetchAllCount += 1
        return stubbedFetchAllResult
    }

    var invokedCreateCount = 0
    var invokedCreateTitle: String?
    var stubbedCreateResponse: Todo?
    func create(title: String, on eventLoop: EventLoop) async throws -> Todo {
        invokedCreateCount += 1
        invokedCreateTitle = title
        return stubbedCreateResponse!
    }

    var invokedDeleteCount = 0
    var invokedDeleteId: UUID?
    func delete(id: UUID, on eventLoop: EventLoop) async throws {
        invokedDeleteCount += 1
        invokedDeleteId = id
    }
}
