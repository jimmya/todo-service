import Vapor
import Fluent

extension Application {

    public func db(_ id: DatabaseID? = nil, on eventLoop: EventLoop) -> Database {
        self.databases
            .database(
                id,
                logger: logger,
                on: eventLoop,
                history: nil,
                pageSizeLimit: fluent.pagination.pageSizeLimit
            )!
    }
}
