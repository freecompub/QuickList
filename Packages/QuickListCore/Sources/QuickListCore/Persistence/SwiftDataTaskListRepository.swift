import Foundation
import SwiftData

@MainActor
public final class SwiftDataTaskListRepository: TaskListRepository {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func fetchAll() throws -> [TaskList] {
        let descriptor = FetchDescriptor<TaskList>(
            sortBy: [SortDescriptor(\TaskList.createdAt, order: .forward)]
        )
        return try context.fetch(descriptor)
    }

    public func create(name: String, type: ListType) throws -> TaskList {
        let list = TaskList(name: name, type: type)
        context.insert(list)
        try context.save()
        return list
    }
}
