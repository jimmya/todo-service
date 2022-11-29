import Vapor

struct TodoResponse: Content {

    let id: UUID
    let title: String

    init(todo: Todo) throws {
        guard let id = todo.id else {
            throw Abort(.internalServerError)
        }
        self.id = id
        self.title = todo.title
    }
}
