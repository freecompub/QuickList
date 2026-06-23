import Foundation
import QuickListCore

@MainActor
final class MockListItemRepository: ListItemRepository {
    enum Behavior {
        case success
        case fail(Error)
    }

    var behavior: Behavior = .success
    private(set) var createdTitles: [String] = []
    private(set) var lastList: TaskList?

    func create(title: String, in list: TaskList) throws -> ListItem {
        switch behavior {
        case .success:
            createdTitles.append(title)
            lastList = list
            let item = ListItem(title: title)
            item.list = list
            return item
        case .fail(let error):
            throw error
        }
    }
}
