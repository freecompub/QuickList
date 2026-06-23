import Foundation

@MainActor
public protocol ListItemRepository: AnyObject {
    func create(title: String, in list: TaskList) throws -> ListItem
    func updateCategory(_ item: ListItem, to category: String?) throws
}
