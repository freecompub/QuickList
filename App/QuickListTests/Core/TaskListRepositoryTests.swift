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
}
