import Foundation
import QuickListCore

@MainActor
final class MockListItemRepository: ListItemRepository {
    enum Behavior {
        case success
        case fail(Error)
    }

    var behavior: Behavior = .success
    var updateCategoryBehavior: Behavior = .success
    private(set) var createdTitles: [String] = []
    private(set) var lastList: TaskList?
    private(set) var lastCreatedItem: ListItem?
    private(set) var categoryUpdates: [(ListItem, String?)] = []

    func create(title: String, in list: TaskList) throws -> ListItem {
        switch behavior {
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

    func updateCategory(_ item: ListItem, to category: String?) throws {
        switch updateCategoryBehavior {
        case .success:
            item.category = category
            categoryUpdates.append((item, category))
        case .fail(let error):
            throw error
        }
    }
}
