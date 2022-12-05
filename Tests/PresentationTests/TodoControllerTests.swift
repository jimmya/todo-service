@testable import Presentation
@testable import Domain
import XCTest
import Vapor
import XCTVapor
import NIOPosix

final class TodoControllerTests: XCTestCase {

    var eventLoopGroup: MultiThreadedEventLoopGroup!
    var mockService: MockTodoService!
    var mockApplication: Application!
    var sut: TodoController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApplication = Application(.testing)
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        mockService = MockTodoService()
        sut = TodoController(service: mockService)
    }

    func testSomething() async throws {
        // When
        let body = ByteBuffer(string: "{\"title\": \"Foo\"}")
        let request = Request(application: mockApplication, headers: ["Content-Type": "application/json"], collectedBody: body, on: eventLoopGroup.next())
        let response = try await sut.create(req: request)
        print("Foo")
    }
}

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
