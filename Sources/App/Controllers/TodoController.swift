import Fluent
import Vapor

struct TodoController: RouteCollection {

    private let service: TodoServiceLogic

    init(service: TodoServiceLogic) {
        self.service = service
    }

    func boot(routes: RoutesBuilder) throws {
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

    func create(req: Request) async throws -> TodoResponse {
        let request = try req.content.decode(CreateTodoRequest.self)
        let todo = try await service.create(title: request.title, on: req.eventLoop)
        return try TodoResponse(todo: todo)
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

    var status: HTTPResponseStatus {
        switch self {
            case .notFound: return .notFound
        }
    }
}
