import QuickListAdd
import QuickListAnalytics
import QuickListCore
import XCTest

@MainActor
final class ItemCheckmarkViewModelTests: XCTestCase {

    private var list: TaskList!
    private var repository: MockListItemRepository!
    private var analytics: SpyAnalyticsService!
    private var sut: ItemCheckmarkViewModel!

    override func setUp() {
        super.setUp()
        list = TaskList(name: "Courses", type: .groceries)
        repository = MockListItemRepository()
        analytics = SpyAnalyticsService()
        sut = ItemCheckmarkViewModel(list: list, repository: repository, analytics: analytics)
    }

    override func tearDown() {
        sut = nil
        analytics = nil
        repository = nil
        list = nil
        super.tearDown()
    }

    private func makeItem(isDone: Bool = false) -> ListItem {
        let item = ListItem(title: "Lait")
        item.isDone = isDone
        item.list = list
        return item
    }

    func test_toggle_undoneItem_marksItDoneAndEmitsChecked() {
        let item = makeItem(isDone: false)

        sut.toggle(item)

        XCTAssertTrue(item.isDone)
        XCTAssertEqual(repository.toggleDoneCalls.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_checked")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "groceries")
    }

    func test_toggle_doneItem_marksItUndoneAndEmitsUnchecked() {
        let item = makeItem(isDone: true)

        sut.toggle(item)

        XCTAssertFalse(item.isDone)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_unchecked")
    }

    func test_toggle_failure_setsLastErrorAndEmitsFailureAnalytics() {
        let item = makeItem()
        repository.toggleDoneBehavior = .fail(NSError(domain: "test", code: 1))

        sut.toggle(item)

        XCTAssertEqual(sut.lastError, .persistenceFailed)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_toggle_done_failed")
        XCTAssertFalse(item.isDone, "L'item ne doit pas etre toggle si la persistance echoue")
    }

    func test_toggle_recoversFromError_onNextSuccess() {
        let item = makeItem()
        repository.toggleDoneBehavior = .fail(NSError(domain: "test", code: 1))
        sut.toggle(item)
        XCTAssertEqual(sut.lastError, .persistenceFailed)

        repository.toggleDoneBehavior = .success
        sut.toggle(item)

        XCTAssertNil(sut.lastError)
        XCTAssertTrue(item.isDone)
    }

    func test_dismissError_clearsLastError() {
        let item = makeItem()
        repository.toggleDoneBehavior = .fail(NSError(domain: "test", code: 1))
        sut.toggle(item)
        XCTAssertEqual(sut.lastError, .persistenceFailed)

        sut.dismissError()

        XCTAssertNil(sut.lastError)
    }
}
