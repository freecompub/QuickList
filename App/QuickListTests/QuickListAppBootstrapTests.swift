import SwiftData
import XCTest

@testable import QuickListCore

@MainActor
final class QuickListAppBootstrapTests: XCTestCase {

    func test_inMemorySchema_acceptsTaskListAndListItem() throws {
        let schema = Schema([TaskList.self, ListItem.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)

        let list = TaskList(name: "Démo", type: .tasks)
        context.insert(list)
        try context.save()

        let repository = SwiftDataListItemRepository(context: context)
        _ = try repository.create(title: "Acheter du lait", in: list)
        _ = try repository.create(title: "Pain", in: list)

        let fetched = try context.fetch(FetchDescriptor<ListItem>())
        XCTAssertEqual(fetched.count, 2)
        XCTAssertEqual(Set(fetched.map(\.title)), ["Acheter du lait", "Pain"])
    }
}
