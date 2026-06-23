import QuickListAdd
import QuickListAnalytics
import QuickListCore
import XCTest

@MainActor
final class ListItemActionsViewModelTests: XCTestCase {

    private var list: TaskList!
    private var repository: MockListItemRepository!
    private var analytics: SpyAnalyticsService!
    private var sut: ListItemActionsViewModel!

    override func setUp() {
        super.setUp()
        list = TaskList(name: "Courses")
        repository = MockListItemRepository()
        analytics = SpyAnalyticsService()
        sut = ListItemActionsViewModel(
            list: list,
            repository: repository,
            analytics: analytics,
            undoTimeout: 60
        )
    }

    override func tearDown() {
        sut = nil
        analytics = nil
        repository = nil
        list = nil
        super.tearDown()
    }

    private func makeItem(title: String = "Lait") -> ListItem {
        let item = ListItem(title: title)
        item.list = list
        return item
    }

    func test_delete_callsRepositoryAndSetsPendingUndo() {
        let item = makeItem(title: "Lait")

        sut.delete(item)

        XCTAssertEqual(repository.deletedItems.count, 1)
        XCTAssertEqual(sut.pendingUndo?.snapshot.title, "Lait")
    }

    func test_delete_doesNotEmitDeletedEventImmediately() {
        let item = makeItem()

        sut.delete(item)

        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_delete_failure_setsLastErrorAndEmitsFailureAnalytics() {
        repository.deleteBehavior = .fail(NSError(domain: "test", code: 1))
        let item = makeItem()

        sut.delete(item)

        XCTAssertEqual(sut.lastError, .deleteFailed)
        XCTAssertNil(sut.pendingUndo)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_delete_failed")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "tasks")
    }

    func test_undoLastDeletion_restoresItemAndEmitsAnalytics() {
        let item = makeItem(title: "Lait")
        sut.delete(item)

        sut.undoLastDeletion()

        XCTAssertEqual(repository.restoredSnapshots.count, 1)
        XCTAssertEqual(repository.restoredSnapshots.first?.title, "Lait")
        XCTAssertNil(sut.pendingUndo)
        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_delete_undone")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "tasks")
    }

    func test_undoLastDeletion_noPending_doesNothing() {
        sut.undoLastDeletion()

        XCTAssertTrue(repository.restoredSnapshots.isEmpty)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_undo_failure_setsRestoreError() {
        repository.restoreBehavior = .fail(NSError(domain: "test", code: 1))
        let item = makeItem()
        sut.delete(item)

        sut.undoLastDeletion()

        XCTAssertEqual(sut.lastError, .restoreFailed)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_delete_undo_failed")
    }

    func test_commitPendingDeletion_emitsItemDeletedAndClearsPending() {
        let item = makeItem()
        sut.delete(item)

        sut.commitPendingDeletion()

        XCTAssertNil(sut.pendingUndo)
        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_deleted")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "tasks")
    }

    func test_commitPendingDeletion_withoutPending_doesNothing() {
        sut.commitPendingDeletion()

        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_delete_secondDeletion_replacesPendingAndDoesNotConfirmFirst() {
        let first = makeItem(title: "Lait")
        let second = makeItem(title: "Pain")

        sut.delete(first)
        sut.delete(second)

        XCTAssertEqual(sut.pendingUndo?.snapshot.title, "Pain")
        XCTAssertEqual(repository.deletedItems.count, 2)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_dismissError_clearsLastError() {
        repository.deleteBehavior = .fail(NSError(domain: "test", code: 1))
        sut.delete(makeItem())
        XCTAssertEqual(sut.lastError, .deleteFailed)

        sut.dismissError()

        XCTAssertNil(sut.lastError)
    }

    func test_delete_clearsPreviousError() {
        repository.deleteBehavior = .fail(NSError(domain: "test", code: 1))
        sut.delete(makeItem())
        XCTAssertEqual(sut.lastError, .deleteFailed)

        repository.deleteBehavior = .success
        sut.delete(makeItem(title: "Pain"))

        XCTAssertNil(sut.lastError)
    }

    func test_snapshotPreservesCreatedAtForOrderingRestoration() {
        let item = makeItem(title: "Lait")
        let originalDate = Date(timeIntervalSince1970: 1_000_000)
        item.createdAt = originalDate

        sut.delete(item)
        sut.undoLastDeletion()

        XCTAssertEqual(repository.lastRestoredItem?.createdAt, originalDate)
    }

    func test_undoTimeout_eventuallyCommitsWithShortTimer() async {
        sut = ListItemActionsViewModel(
            list: list,
            repository: repository,
            analytics: analytics,
            undoTimeout: 0.01
        )
        let item = makeItem()
        sut.delete(item)

        for _ in 0..<50 where sut.pendingUndo != nil {
            try? await Task.sleep(nanoseconds: 20_000_000)
        }

        XCTAssertNil(sut.pendingUndo)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_deleted")
    }
}
