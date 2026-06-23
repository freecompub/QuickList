import QuickListCore
import SwiftData
import XCTest

@MainActor
final class TaskListModelTests: XCTestCase {

    func test_createsTaskList_withDefaults() {
        let list = TaskList(name: "Démo")
        XCTAssertEqual(list.name, "Démo")
        XCTAssertEqual(list.type, .tasks)
        XCTAssertEqual(list.sortMode, .dateAdded)
        XCTAssertEqual(list.items?.isEmpty, true)
    }

    func test_repository_create_inserts_persistsAndLinksToList() throws {
        let schema = Schema([TaskList.self, ListItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        let list = TaskList(name: "Tâches")
        context.insert(list)

        let repository = SwiftDataListItemRepository(context: context)
        let item = try repository.create(title: "Acheter du lait", in: list)

        XCTAssertEqual(item.title, "Acheter du lait")
        XCTAssertIdentical(item.list, list)
        let descriptor = FetchDescriptor<ListItem>()
        let fetched = try context.fetch(descriptor)
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.title, "Acheter du lait")
    }

    func test_repository_create_throwsForEmptyTitle() throws {
        let schema = Schema([TaskList.self, ListItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        let list = TaskList(name: "Tâches")
        context.insert(list)

        let repository = SwiftDataListItemRepository(context: context)
        XCTAssertThrowsError(try repository.create(title: "   ", in: list)) { error in
            XCTAssertEqual(error as? ListItemRepositoryError, .emptyTitle)
        }
    }

    func test_repository_create_trimsWhitespace() throws {
        let schema = Schema([TaskList.self, ListItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        let list = TaskList(name: "Tâches")
        context.insert(list)

        let repository = SwiftDataListItemRepository(context: context)
        let item = try repository.create(title: "  Pain  ", in: list)

        XCTAssertEqual(item.title, "Pain")
    }
}
