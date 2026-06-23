import Foundation
import SwiftData

@MainActor
public final class SwiftDataListItemRepository: ListItemRepository {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func create(title: String, in list: TaskList) throws -> ListItem {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw ListItemRepositoryError.emptyTitle
        }
        let item = ListItem(title: trimmed)
        item.list = list
        context.insert(item)
        try context.save()
        return item
    }

    public func updateCategory(_ item: ListItem, to category: String?) throws {
        item.category = category
        try context.save()
    }

    public func toggleDone(_ item: ListItem) throws {
        item.isDone.toggle()
        try context.save()
    }
}
