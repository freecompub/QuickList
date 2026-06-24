import QuickListCore
import SwiftData
import XCTest

@MainActor
final class TaskListRepositoryTests: XCTestCase {

    private func makeRepository() throws -> SwiftDataTaskListRepository {
        let schema = Schema([TaskList.self, ListItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        return SwiftDataTaskListRepository(context: context)
    }

    func test_create_persistsList() throws {
        let repo = try makeRepository()

        let list = try repo.create(name: "Démo", type: .tasks)

        XCTAssertEqual(list.name, "Démo")
        XCTAssertEqual(list.type, .tasks)
        let fetched = try repo.fetchAll()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.name, "Démo")
    }

    func test_fetchAll_returnsEmpty_whenNothingPersisted() throws {
        let repo = try makeRepository()

        let fetched = try repo.fetchAll()

        XCTAssertTrue(fetched.isEmpty)
    }

    func test_fetchAll_isSortedByCreatedAt() throws {
        let repo = try makeRepository()
        let first = try repo.create(name: "Premier", type: .tasks)
        let second = try repo.create(name: "Second", type: .ideas)

        let fetched = try repo.fetchAll()

        XCTAssertEqual(fetched.count, 2)
        XCTAssertEqual(fetched[0].id, first.id)
        XCTAssertEqual(fetched[1].id, second.id)
    }

    func test_rename_updatesNameAndPersists() throws {
        let repo = try makeRepository()
        let list = try repo.create(name: "Old", type: .tasks)

        try repo.rename(list, to: "  New  ")

        XCTAssertEqual(list.name, "New")
        let fetched = try repo.fetchAll()
        XCTAssertEqual(fetched.first?.name, "New")
    }

    func test_rename_emptyName_throwsAndKeepsName() throws {
        let repo = try makeRepository()
        let list = try repo.create(name: "Original", type: .tasks)

        XCTAssertThrowsError(try repo.rename(list, to: "   ")) { error in
            XCTAssertEqual(error as? TaskListRepositoryError, .emptyName)
        }
        XCTAssertEqual(list.name, "Original")
    }

    func test_delete_removesListFromStore() throws {
        let repo = try makeRepository()
        let list = try repo.create(name: "Tâches", type: .tasks)
        _ = try repo.create(name: "Idées", type: .ideas)

        try repo.delete(list)

        let fetched = try repo.fetchAll()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.name, "Idées")
    }

    func test_delete_cascadesItemsBelongingToTheList() throws {
        let schema = Schema([TaskList.self, ListItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        let listRepo = SwiftDataTaskListRepository(context: context)
        let itemRepo = SwiftDataListItemRepository(context: context)
        let list = try listRepo.create(name: "Courses", type: .groceries)
        _ = try itemRepo.create(title: "Pain", in: list)
        _ = try itemRepo.create(title: "Lait", in: list)
        XCTAssertEqual(try context.fetch(FetchDescriptor<ListItem>()).count, 2)

        try listRepo.delete(list)

        XCTAssertTrue(try context.fetch(FetchDescriptor<ListItem>()).isEmpty)
        XCTAssertTrue(try listRepo.fetchAll().isEmpty)
    }
}
