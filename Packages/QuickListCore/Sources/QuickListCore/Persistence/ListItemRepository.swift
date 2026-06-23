import Foundation

@MainActor
public protocol ListItemRepository: AnyObject {
    func create(title: String, in list: TaskList) throws -> ListItem
    func delete(_ item: ListItem) throws
    func restore(_ snapshot: ListItemSnapshot, in list: TaskList) throws -> ListItem
}
