import QuickListAdd
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

    func test_submit_groceriesList_schedulesClassificationOnCoordinator() async {
        let groceries = TaskList(name: "Courses", type: .groceries)
        let repo = MockListItemRepository()
        let aSpy = SpyAnalyticsService()
        let langService = MockLanguageModelService()
        langService.behavior = .success(.cremerie)
        let coordinator = RayonClassificationCoordinator(
            service: langService,
            repository: repo,
            analytics: aSpy
        )
        let viewModel = AddItemViewModel(
            list: groceries,
            repository: repo,
            analytics: aSpy,
            classificationCoordinator: coordinator
        )
        viewModel.pendingTitle = "Lait"

        viewModel.submit()

        for _ in 0..<50 where langService.classifyRequests.isEmpty {
            try? await Task.sleep(nanoseconds: 20_000_000)
        }
        XCTAssertEqual(langService.classifyRequests, ["Lait"])
    }

    func test_submit_nonGroceriesList_doesNotCallLanguageModel() async {
        let tasks = TaskList(name: "Tâches", type: .tasks)
        let repo = MockListItemRepository()
        let aSpy = SpyAnalyticsService()
        let langService = MockLanguageModelService()
        let coordinator = RayonClassificationCoordinator(
            service: langService,
            repository: repo,
            analytics: aSpy
        )
        let viewModel = AddItemViewModel(
            list: tasks,
            repository: repo,
            analytics: aSpy,
            classificationCoordinator: coordinator
        )
        viewModel.pendingTitle = "Appeler le dentiste"

        viewModel.submit()

        try? await Task.sleep(nanoseconds: 80_000_000)
        XCTAssertTrue(langService.classifyRequests.isEmpty)
    }

    func test_submit_repositoryFailure_keepsFieldAndSurfacesError() {
        repository.behavior = .fail(ListItemRepositoryError.emptyTitle)
        sut.pendingTitle = "Lait"

        sut.submit()

        XCTAssertEqual(sut.pendingTitle, "Lait")
        XCTAssertEqual(sut.lastError, .persistenceFailed)
    }

    func test_submit_repositoryFailure_emitsFailureAnalyticsEvent() {
        repository.behavior = .fail(ListItemRepositoryError.emptyTitle)
        sut.pendingTitle = "Lait"

        sut.submit()

        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_add_failed")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["reason"], "persistence")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "tasks")
    }

    func test_submit_clearsLastErrorOnSuccess() {
        repository.behavior = .fail(ListItemRepositoryError.emptyTitle)
        sut.pendingTitle = "Lait"
        sut.submit()
        XCTAssertEqual(sut.lastError, .persistenceFailed)

        repository.behavior = .success
        sut.submit()

        XCTAssertNil(sut.lastError)
    }

    func test_dismissError_clearsLastError() {
        repository.behavior = .fail(ListItemRepositoryError.emptyTitle)
        sut.pendingTitle = "Lait"
        sut.submit()

        sut.dismissError()

        XCTAssertNil(sut.lastError)
    }

    func test_itemsBelongingToList_filtersByPersistentModelID() {
        let otherList = TaskList(name: "Idées")
        sut.pendingTitle = "Lait"
        sut.submit()
        let mineItem = repository.lastCreatedItem
        XCTAssertNotNil(mineItem)
        let unrelatedItem = ListItem(title: "Pizza")
        unrelatedItem.list = otherList

        let filtered = sut.itemsBelongingToList(in: [unrelatedItem, mineItem!])

        XCTAssertEqual(filtered.count, 1)
        XCTAssertIdentical(filtered.first, mineItem)
    }
}
