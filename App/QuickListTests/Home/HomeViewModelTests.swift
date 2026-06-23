import QuickListAnalytics
import QuickListCore
import QuickListDesignSystem
import QuickListLists
import XCTest

@MainActor
final class HomeViewModelTests: XCTestCase {

    private var analytics: SpyAnalyticsService!
    private var sut: HomeViewModel!

    override func setUp() {
        super.setUp()
        analytics = SpyAnalyticsService()
        sut = HomeViewModel(analytics: analytics)
    }

    override func tearDown() {
        sut = nil
        analytics = nil
        super.tearDown()
    }

    private func makeList(
        name: String = "Tâches",
        type: ListType = .tasks,
        doneCount: Int = 0,
        openCount: Int = 0
    ) -> TaskList {
        let list = TaskList(name: name, type: type)
        var items: [ListItem] = []
        for index in 0..<doneCount {
            let item = ListItem(title: "Done \(index)")
            item.isDone = true
            item.list = list
            items.append(item)
        }
        for index in 0..<openCount {
            let item = ListItem(title: "Open \(index)")
            item.isDone = false
            item.list = list
            items.append(item)
        }
        list.items = items
        return list
    }

    func test_unfinishedItemsCount_isZeroForEmptyList() {
        let list = TaskList(name: "Vide")
        list.items = []

        XCTAssertEqual(sut.unfinishedItemsCount(in: list), 0)
    }

    func test_unfinishedItemsCount_countsOnlyOpenItems() {
        let list = makeList(doneCount: 3, openCount: 4)

        XCTAssertEqual(sut.unfinishedItemsCount(in: list), 4)
    }

    func test_unfinishedItemsCount_handlesNilItems() {
        let list = TaskList(name: "Lone")
        list.items = nil

        XCTAssertEqual(sut.unfinishedItemsCount(in: list), 0)
    }

    func test_totalItemsCount_countsAllItems() {
        let list = makeList(doneCount: 3, openCount: 4)

        XCTAssertEqual(sut.totalItemsCount(in: list), 7)
    }

    func test_totalItemsCount_handlesNilItems() {
        let list = TaskList(name: "Lone")
        list.items = nil

        XCTAssertEqual(sut.totalItemsCount(in: list), 0)
    }

    func test_subtitle_isZeroLabelForEmptyList() {
        let list = TaskList(name: "Vide")
        list.items = []

        XCTAssertEqual(sut.subtitle(for: list), QuickListStrings.itemCount(0))
    }

    func test_subtitle_isSingularForOneItem() {
        let list = makeList(openCount: 1)

        XCTAssertEqual(sut.subtitle(for: list), QuickListStrings.itemCount(1))
    }

    func test_subtitle_isPluralForMultipleItems() {
        let list = makeList(openCount: 4)

        XCTAssertEqual(sut.subtitle(for: list), QuickListStrings.itemCount(4))
    }

    func test_presentation_returnsMatchingTypePresentation() {
        let groceries = TaskList(name: "Courses", type: .groceries)

        let presentation = sut.presentation(for: groceries)

        XCTAssertEqual(presentation.kind, .groceries)
    }

    func test_presentation_mapsEachListType_toExpectedKind() {
        let expectations: [(ListType, ListTypeKind)] = [
            (.groceries, .groceries),
            (.tasks, .tasks),
            (.ideas, .ideas),
            (.projects, .projects),
            (.favorites, .favorites)
        ]
        for (type, expected) in expectations {
            let list = TaskList(name: "X", type: type)
            XCTAssertEqual(sut.presentation(for: list).kind, expected)
        }
    }

    func test_listDidOpen_emitsListOpenedAnalytics() {
        let list = TaskList(name: "Courses", type: .groceries)

        sut.listDidOpen(list)

        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_opened")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "groceries")
    }
}
