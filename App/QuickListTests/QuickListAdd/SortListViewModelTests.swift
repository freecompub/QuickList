import QuickListAdd
import QuickListAnalytics
import QuickListCore
import XCTest

@MainActor
final class SortListViewModelTests: XCTestCase {

    private var list: TaskList!
    private var repository: MockTaskListRepository!
    private var analytics: SpyAnalyticsService!
    private var sut: SortListViewModel!

    override func setUp() {
        super.setUp()
        list = TaskList(name: "Tâches", type: .tasks)
        repository = MockTaskListRepository()
        analytics = SpyAnalyticsService()
        sut = SortListViewModel(list: list, repository: repository, analytics: analytics)
    }

    override func tearDown() {
        sut = nil
        analytics = nil
        repository = nil
        list = nil
        super.tearDown()
    }

    private func makeItem(_ title: String, isDone: Bool = false, secondsAgo: TimeInterval = 0) -> ListItem {
        let item = ListItem(title: title)
        item.isDone = isDone
        item.createdAt = Date(timeIntervalSince1970: 1_000_000 - secondsAgo)
        return item
    }

    func test_initialState_currentSortModeReflectsList() {
        XCTAssertEqual(sut.currentSortMode, .dateAdded)
        XCTAssertNil(sut.lastError)
    }

    func test_setSortMode_persistsAndEmitsAnalytics() {
        sut.setSortMode(.alphabetical)

        XCTAssertEqual(list.sortMode, .alphabetical)
        XCTAssertEqual(repository.updatedSortModes.count, 1)
        XCTAssertEqual(repository.updatedSortModes.first?.1, .alphabetical)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_sort_changed")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["sort_mode"], "alphabetical")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "tasks")
    }

    func test_setSortMode_sameMode_doesNothing() {
        sut.setSortMode(.dateAdded)

        XCTAssertTrue(repository.updatedSortModes.isEmpty)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_setSortMode_failure_setsLastErrorAndEmitsFailureAnalytics() {
        repository.updateSortModeBehavior = .fail(NSError(domain: "test", code: 1))

        sut.setSortMode(.status)

        XCTAssertEqual(sut.lastError, .persistenceFailed)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_sort_change_failed")
    }

    func test_dismissError_clearsLastError() {
        repository.updateSortModeBehavior = .fail(NSError(domain: "test", code: 1))
        sut.setSortMode(.status)
        XCTAssertEqual(sut.lastError, .persistenceFailed)

        sut.dismissError()

        XCTAssertNil(sut.lastError)
    }

    func test_sortedItems_dateAdded_sortsAscendingByCreatedAt() {
        list.sortMode = .dateAdded
        let oldest = makeItem("A", secondsAgo: 100)
        let newest = makeItem("B", secondsAgo: 0)
        let middle = makeItem("C", secondsAgo: 50)

        let sorted = sut.sortedItems([newest, oldest, middle])

        XCTAssertEqual(sorted.map(\.title), ["A", "C", "B"])
    }

    func test_sortedItems_alphabetical_caseInsensitiveAscending() {
        list.sortMode = .alphabetical
        let items = [
            makeItem("banana"),
            makeItem("Apple"),
            makeItem("cherry")
        ]

        let sorted = sut.sortedItems(items)

        XCTAssertEqual(sorted.map(\.title), ["Apple", "banana", "cherry"])
    }

    func test_sortedItems_status_unfinishedFirst_thenByDate() {
        list.sortMode = .status
        let oldDone = makeItem("OldDone", isDone: true, secondsAgo: 100)
        let recentDone = makeItem("RecentDone", isDone: true, secondsAgo: 0)
        let oldOpen = makeItem("OldOpen", isDone: false, secondsAgo: 80)
        let recentOpen = makeItem("RecentOpen", isDone: false, secondsAgo: 10)

        let sorted = sut.sortedItems([recentDone, oldOpen, oldDone, recentOpen])

        XCTAssertEqual(sorted.map(\.title), ["OldOpen", "RecentOpen", "OldDone", "RecentDone"])
    }

    func test_sortedItems_handlesEmptyArray() {
        XCTAssertTrue(sut.sortedItems([]).isEmpty)
    }

    func test_setSortMode_sameModeWhenAlreadyPersistedDifferently_isNoOp() {
        list.sortMode = .alphabetical

        sut.setSortMode(.alphabetical)

        XCTAssertTrue(repository.updatedSortModes.isEmpty)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_sortedItems_alphabetical_handlesAccentsCaseInsensitive() {
        list.sortMode = .alphabetical
        let items = [
            makeItem("banane"),
            makeItem("Éclair"),
            makeItem("école")
        ]

        let sorted = sut.sortedItems(items)

        // Tri localise case-insensitive : 'Éclair' < 'école' (E equivalents,
        // ensuite 'c' = 'c', puis 'l' < 'o').
        XCTAssertEqual(sorted.map(\.title), ["banane", "Éclair", "école"])
    }
}
