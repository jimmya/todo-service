import Fluent
import Vapor
import Domain

public struct TodoController: RouteCollection {

    private let service: TodoServiceLogic

    public init(service: TodoServiceLogic) {
        self.service = service
    }

    public func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [TodoResponse] {
        try await service.fetchAll(on: req.eventLoop).map(TodoResponse.init)
    }

    func create(req: Request) async throws -> Response {
        let request = try req.content.decode(CreateTodoRequest.self)
        let todo = try await service.create(title: request.title, on: req.eventLoop)
        let response = try await TodoResponse(todo: todo).encodeResponse(for: req)
        response.status = .created
        return response
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let id: UUID = req.parameters.get("todoID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        try await service.delete(id: id, on: req.eventLoop)
        return .noContent
    }
}

extension TodoServiceError: AbortError {

    public var status: HTTPResponseStatus {
        switch self {
            case .notFound: return .notFound
        }
    }
}
