import Fluent
import Vapor
import Domain

final class TodoEntity: Model, Content {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }

    init(todo: Todo) {
        self.id = todo.id
        self.title = todo.title
    }

    var todo: Todo {
        Todo(id: id, title: title)
    }
}
