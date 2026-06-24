import Foundation

public struct ListItemSnapshot: Equatable, Sendable {
    public let title: String
    public let category: String?
    public let isDone: Bool
    public let createdAt: Date

    public init(title: String, category: String?, isDone: Bool, createdAt: Date) {
        self.title = title
        self.category = category
        self.isDone = isDone
        self.createdAt = createdAt
    }
}

public extension ListItem {
    func snapshot() -> ListItemSnapshot {
        ListItemSnapshot(
            title: title,
            category: category,
            isDone: isDone,
            createdAt: createdAt
        )
    }
}
