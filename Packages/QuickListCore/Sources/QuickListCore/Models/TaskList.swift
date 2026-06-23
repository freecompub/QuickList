import Foundation
import SwiftData

@Model
public final class TaskList {
    public var id: UUID = UUID()
    public var name: String = ""
    public var type: ListType = ListType.tasks
    public var sortMode: SortMode = SortMode.dateAdded
    public var createdAt: Date = Date()

    @Relationship(deleteRule: .cascade, inverse: \ListItem.list)
    public var items: [ListItem]? = []

    public init(name: String, type: ListType = .tasks) {
        self.name = name
        self.type = type
    }
}
