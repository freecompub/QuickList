import QuickAdd
import QuickListAnalytics
import QuickListCore
import XCTest

@MainActor
final class AddItemViewModelTests: XCTestCase {

    private var list: TaskList!
    private var repository: MockListItemRepository!
    private var analytics: SpyAnalyticsService!
    private var sut: AddItemViewModel!

    override func setUp() {
        super.setUp()
        list = TaskList(name: "Tâches")
        repository = MockListItemRepository()
        analytics = SpyAnalyticsService()
        sut = AddItemViewModel(list: list, repository: repository, analytics: analytics)
    }

    override func tearDown() {
        sut = nil
        analytics = nil
        repository = nil
        list = nil
        super.tearDown()
    }

    func test_submit_withWhitespaceOnly_doesNothing() {
        sut.pendingTitle = "   "

        sut.submit()

        XCTAssertEqual(sut.pendingTitle, "   ")
        XCTAssertTrue(repository.createdTitles.isEmpty)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_submit_emptyTitle_doesNotChangeState() {
        sut.pendingTitle = ""

        sut.submit()

        XCTAssertEqual(sut.pendingTitle, "")
        XCTAssertTrue(repository.createdTitles.isEmpty)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_submit_validTitle_createsItem() {
        sut.pendingTitle = "Acheter du lait"

        sut.submit()

        XCTAssertEqual(repository.createdTitles, ["Acheter du lait"])
        XCTAssertIdentical(repository.lastList, list)
    }

    func test_submit_clearsFieldOnSuccess() {
        sut.pendingTitle = "Acheter du lait"

        sut.submit()

        XCTAssertEqual(sut.pendingTitle, "")
    }

    func test_submit_emitsAnalyticsEventOnSuccess() {
        sut.pendingTitle = "Acheter du lait"

        sut.submit()

        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_added")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "tasks")
    }

    func test_canSubmit_isFalseForEmpty() {
        sut.pendingTitle = ""
        XCTAssertFalse(sut.canSubmit)
    }

    func test_canSubmit_isFalseForWhitespace() {
        sut.pendingTitle = " \n\t"
        XCTAssertFalse(sut.canSubmit)
    }

    func test_canSubmit_isTrueForNonEmpty() {
        sut.pendingTitle = "Pain"
        XCTAssertTrue(sut.canSubmit)
    }

    func test_submit_allowsRafale_consecutiveAdds() {
        sut.pendingTitle = "Lait"
        sut.submit()
        sut.pendingTitle = "Pain"
        sut.submit()
        sut.pendingTitle = "Beurre"
        sut.submit()

        XCTAssertEqual(repository.createdTitles, ["Lait", "Pain", "Beurre"])
        XCTAssertEqual(analytics.trackedEvents.count, 3)
        XCTAssertEqual(sut.pendingTitle, "")
    }

    func test_submit_repositoryFailure_keepsFieldAndSkipsAnalytics() {
        repository.behavior = .fail(ListItemRepositoryError.emptyTitle)
        sut.pendingTitle = "Lait"

        sut.submit()

        XCTAssertEqual(sut.pendingTitle, "Lait")
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }
}
