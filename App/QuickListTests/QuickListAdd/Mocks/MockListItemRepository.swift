import Foundation
import QuickListCore

@MainActor
final class MockListItemRepository: ListItemRepository {
    enum Behavior {
        case success
        case fail(Error)
    }

    var createBehavior: Behavior = .success
    var deleteBehavior: Behavior = .success
    var restoreBehavior: Behavior = .success

    private(set) var createdTitles: [String] = []
    private(set) var lastList: TaskList?
    private(set) var lastCreatedItem: ListItem?
    private(set) var deletedItems: [ListItem] = []
    private(set) var restoredSnapshots: [ListItemSnapshot] = []
    private(set) var lastRestoredItem: ListItem?

    var behavior: Behavior {
        get { createBehavior }
        set { createBehavior = newValue }
    }

    func create(title: String, in list: TaskList) throws -> ListItem {
        switch createBehavior {
        case .success:
            createdTitles.append(title)
            lastList = list
            let item = ListItem(title: title)
            item.list = list
            lastCreatedItem = item
            return item
        case .fail(let error):
            throw error
        }
    }

    func delete(_ item: ListItem) throws {
        switch deleteBehavior {
        case .success:
            deletedItems.append(item)
        case .fail(let error):
            throw error
        }
    }

    func restore(_ snapshot: ListItemSnapshot, in list: TaskList) throws -> ListItem {
        switch restoreBehavior {
        case .success:
            restoredSnapshots.append(snapshot)
            lastList = list
            let item = ListItem(title: snapshot.title, category: snapshot.category)
            item.isDone = snapshot.isDone
            item.createdAt = snapshot.createdAt
            item.list = list
            lastRestoredItem = item
            return item
        case .fail(let error):
            throw error
        }
    }
}
