import QuickListAnalytics
import QuickListCore
import QuickListLists
import XCTest

@MainActor
final class ListOptionsViewModelTests: XCTestCase {

    private var list: TaskList!
    private var repository: MockTaskListRepository!
    private var analytics: SpyAnalyticsService!
    private var sut: ListOptionsViewModel!

    override func setUp() {
        super.setUp()
        list = TaskList(name: "Tâches", type: .tasks)
        repository = MockTaskListRepository()
        analytics = SpyAnalyticsService()
        sut = ListOptionsViewModel(list: list, repository: repository, analytics: analytics)
    }

    override func tearDown() {
        sut = nil
        analytics = nil
        repository = nil
        list = nil
        super.tearDown()
    }

    func test_initialState_draftEqualsCurrentName() {
        XCTAssertEqual(sut.draftName, "Tâches")
        XCTAssertFalse(sut.canRename)
        XCTAssertFalse(sut.didRename)
        XCTAssertFalse(sut.didDelete)
        XCTAssertNil(sut.lastError)
    }

    func test_canRename_isFalseForEmptyDraft() {
        sut.draftName = "  "
        XCTAssertFalse(sut.canRename)
    }

    func test_canRename_isFalseWhenDraftEqualsCurrentName() {
        sut.draftName = "Tâches"
        XCTAssertFalse(sut.canRename)
    }

    func test_canRename_isTrueForNewNonEmptyName() {
        sut.draftName = "Mon plan"
        XCTAssertTrue(sut.canRename)
    }

    func test_rename_persistsAndEmitsAnalytics() {
        sut.draftName = "Boulot"

        sut.rename()

        XCTAssertEqual(repository.renamedLists.count, 1)
        XCTAssertEqual(repository.renamedLists.first?.1, "Boulot")
        XCTAssertEqual(list.name, "Boulot")
        XCTAssertTrue(sut.didRename)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_renamed")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "tasks")
    }

    func test_rename_trimsWhitespace() {
        sut.draftName = "   Boulot   "

        sut.rename()

        XCTAssertEqual(list.name, "Boulot")
    }

    func test_rename_emptyName_setsErrorAndDoesNotPersist() {
        sut.draftName = "    "

        sut.rename()

        XCTAssertEqual(sut.lastError, .emptyName)
        XCTAssertTrue(repository.renamedLists.isEmpty)
        XCTAssertFalse(sut.didRename)
    }

    func test_rename_sameName_doesNothing() {
        sut.draftName = "Tâches"

        sut.rename()

        XCTAssertTrue(repository.renamedLists.isEmpty)
        XCTAssertFalse(sut.didRename)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_rename_failure_setsRenameFailedAndEmitsFailureAnalytics() {
        repository.renameBehavior = .fail(NSError(domain: "test", code: 1))
        sut.draftName = "Boulot"

        sut.rename()

        XCTAssertEqual(sut.lastError, .renameFailed)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_rename_failed")
    }

    func test_delete_callsRepositoryAndEmitsAnalytics() {
        sut.delete()

        XCTAssertEqual(repository.deletedLists.count, 1)
        XCTAssertTrue(sut.didDelete)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_deleted")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "tasks")
    }

    func test_delete_failure_setsDeleteFailedAndEmitsFailureAnalytics() {
        repository.deleteBehavior = .fail(NSError(domain: "test", code: 1))

        sut.delete()

        XCTAssertEqual(sut.lastError, .deleteFailed)
        XCTAssertFalse(sut.didDelete)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_delete_failed")
    }

    func test_dismissError_clearsLastError() {
        repository.renameBehavior = .fail(NSError(domain: "test", code: 1))
        sut.draftName = "Boulot"
        sut.rename()
        XCTAssertEqual(sut.lastError, .renameFailed)

        sut.dismissError()

        XCTAssertNil(sut.lastError)
    }

    func test_resetDraftName_restoresCurrentName() {
        sut.draftName = "Boulot"

        sut.resetDraftName()

        XCTAssertEqual(sut.draftName, "Tâches")
    }

    func test_acknowledgeRename_clearsDidRename() {
        sut.draftName = "Boulot"
        sut.rename()
        XCTAssertTrue(sut.didRename)

        sut.acknowledgeRename()

        XCTAssertFalse(sut.didRename)
    }

    func test_acknowledgeDelete_clearsDidDelete() {
        sut.delete()
        XCTAssertTrue(sut.didDelete)

        sut.acknowledgeDelete()

        XCTAssertFalse(sut.didDelete)
    }
}
