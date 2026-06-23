import Foundation
import SwiftData

@Model
public final class ListItem {
    public var id: UUID = UUID()
    public var title: String = ""
    public var isDone: Bool = false
    public var category: String?
    public var createdAt: Date = Date()

    public var list: TaskList?

    public init(title: String, category: String? = nil) {
        self.title = title
        self.category = category
    }
}
