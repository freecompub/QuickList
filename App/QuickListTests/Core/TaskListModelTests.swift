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

    func test_repository_delete_removesItemFromStore() throws {
        let schema = Schema([TaskList.self, ListItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        let list = TaskList(name: "Tâches")
        context.insert(list)
        let repository = SwiftDataListItemRepository(context: context)
        let item = try repository.create(title: "Lait", in: list)

        try repository.delete(item)

        let fetched = try context.fetch(FetchDescriptor<ListItem>())
        XCTAssertTrue(fetched.isEmpty)
    }

    func test_repository_restore_recreatesItemWithSameProperties() throws {
        let schema = Schema([TaskList.self, ListItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        let list = TaskList(name: "Tâches")
        context.insert(list)
        let repository = SwiftDataListItemRepository(context: context)
        let original = try repository.create(title: "Lait", in: list)
        original.isDone = true
        original.category = "Crèmerie"
        let snapshot = original.snapshot()
        try repository.delete(original)

        let restored = try repository.restore(snapshot, in: list)

        XCTAssertEqual(restored.title, "Lait")
        XCTAssertEqual(restored.category, "Crèmerie")
        XCTAssertTrue(restored.isDone)
        XCTAssertEqual(restored.createdAt, snapshot.createdAt)
        XCTAssertIdentical(restored.list, list)
    }

    func test_snapshot_capturesAllFields() {
        let item = ListItem(title: "Lait", category: "Crèmerie")
        item.isDone = true
        let originalDate = Date(timeIntervalSince1970: 1_700_000_000)
        item.createdAt = originalDate

        let snapshot = item.snapshot()

        XCTAssertEqual(snapshot.title, "Lait")
        XCTAssertEqual(snapshot.category, "Crèmerie")
        XCTAssertTrue(snapshot.isDone)
        XCTAssertEqual(snapshot.createdAt, originalDate)
    }
}
