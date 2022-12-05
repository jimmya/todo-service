@testable import App
@testable import Presentation
@testable import Domain
import XCTest
import Vapor
import XCTVapor

final class TodoControllerTests: XCTestCase {

    var mockApp: Application!
    var mockService: MockTodoService!
    var sut: TodoController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApp = Application(.testing)
        try configure(mockApp)
        mockService = MockTodoService()
        sut = TodoController(service: mockService)
        mockApp.todoController = sut
    }

    override func tearDown() {
        super.tearDown()
        mockApp.shutdown()
    }

    func test_GET_todos_shouldInvokeService() throws {
        // When
        try mockApp.test(.GET, "/todos")

        // Then
        XCTAssertEqual(mockService.invokedFetchAllCount, 1)
    }

    func test_GET_todos_shouldReturnTodos() throws {
        // Given
        let id = UUID()
        let todo = Todo(id: id, title: "foo")
        mockService.stubbedFetchAllResult = [todo]
        let expectedResponse = [
            try TodoResponse(todo: todo),
        ]

        // When
        try mockApp.test(.GET, "/todos") { res in
            // Then
            XCTAssertEqual(res.status, .ok)
            XCTAssertContent([TodoResponse].self, res) { receivedTodos in
                XCTAssertEqual(receivedTodos, expectedResponse)
            }
        }
    }

    func test_POST_todos_shouldInvokeService() throws {
        // Given
        mockService.stubbedCreateResponse = Todo(id: nil, title: "")
        let body = ByteBuffer(string: "{\"title\": \"Foo\"}")

        // When
        try mockApp.test(.POST, "/todos", headers: ["content-type": "application/json"], body: body)

        // Then
        XCTAssertEqual(mockService.invokedCreateCount, 1)
        XCTAssertEqual(mockService.invokedCreateTitle, "Foo")
    }

    func test_POST_todos_shouldReturnTodo() throws {
        // Given
        let id = UUID()
        let todo = Todo(id: id, title: "foo")
        mockService.stubbedCreateResponse = todo
        let expectedResponse = try TodoResponse(todo: todo)
        let body = ByteBuffer(string: "{\"title\": \"Foo\"}")

        // When
        try mockApp.test(.POST, "/todos", headers: ["content-type": "application/json"], body: body) { res in
            // Then
            XCTAssertEqual(res.status, .created)
            XCTAssertContent(TodoResponse.self, res) { receivedTodo in
                XCTAssertEqual(receivedTodo, expectedResponse)
            }
        }
    }

    func test_DELETE_todos_shouldInvokeService() throws {
        // Given
        let id = UUID()

        // When
        try mockApp.test(.DELETE, "/todos/\(id.uuidString)")

        // Then
        XCTAssertEqual(mockService.invokedDeleteCount, 1)
        XCTAssertEqual(mockService.invokedDeleteId, id)
    }

    func test_DELETE_todos_withoutId_shouldReturnBadRequest() throws {
        // When
        try mockApp.test(.DELETE, "/todos/foo") { res in
            // Then
            XCTAssertEqual(res.status, .badRequest)
        }
    }

    func test_DELETE_todos_shouldReturnNoContent() throws {
        // Given
        let id = UUID()

        // When
        try mockApp.test(.DELETE, "/todos/\(id.uuidString)") { res in
            // Then
            XCTAssertEqual(res.status, .noContent)
        }
    }
}
