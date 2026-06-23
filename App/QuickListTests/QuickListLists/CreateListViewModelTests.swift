import QuickListAnalytics
import QuickListCore
import QuickListLists
import XCTest

@MainActor
final class CreateListViewModelTests: XCTestCase {

    private var repository: MockTaskListRepository!
    private var analytics: SpyAnalyticsService!
    private var sut: CreateListViewModel!

    override func setUp() {
        super.setUp()
        repository = MockTaskListRepository()
        analytics = SpyAnalyticsService()
        sut = CreateListViewModel(repository: repository, analytics: analytics)
    }

    override func tearDown() {
        sut = nil
        analytics = nil
        repository = nil
        super.tearDown()
    }

    func test_initialState_defaultsToTasksType_andEmptyName() {
        XCTAssertEqual(sut.name, "")
        XCTAssertEqual(sut.selectedType, .tasks)
        XCTAssertFalse(sut.canCreate)
        XCTAssertNil(sut.lastError)
        XCTAssertNil(sut.createdList)
    }

    func test_canCreate_isFalseForEmptyName() {
        sut.name = ""
        XCTAssertFalse(sut.canCreate)
    }

    func test_canCreate_isFalseForWhitespaceName() {
        sut.name = "    "
        XCTAssertFalse(sut.canCreate)
    }

    func test_canCreate_isTrueForNonEmptyName() {
        sut.name = "Courses du samedi"
        XCTAssertTrue(sut.canCreate)
    }

    func test_create_withWhitespaceOnly_doesNothing() {
        sut.name = " \n "

        sut.create()

        XCTAssertTrue(repository.createdNames.isEmpty)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
        XCTAssertNil(sut.createdList)
    }

    func test_create_callsRepositoryWithTrimmedNameAndSelectedType() {
        sut.name = "  Courses du samedi  "
        sut.selectedType = .groceries

        sut.create()

        XCTAssertEqual(repository.createdNames, ["Courses du samedi"])
        XCTAssertEqual(repository.createdTypes, [.groceries])
    }

    func test_create_setsCreatedListOnSuccess() {
        sut.name = "Idées"
        sut.selectedType = .ideas

        sut.create()

        XCTAssertNotNil(sut.createdList)
        XCTAssertEqual(sut.createdList?.name, "Idées")
        XCTAssertEqual(sut.createdList?.type, .ideas)
    }

    func test_create_emitsListCreatedAnalyticsEvent() {
        sut.name = "Projets"
        sut.selectedType = .projects

        sut.create()

        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_created")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "projects")
    }

    func test_create_failure_setsLastErrorAndEmitsFailureAnalytics() {
        repository.createBehavior = .fail(NSError(domain: "test", code: 1))
        sut.name = "Favoris"
        sut.selectedType = .favorites

        sut.create()

        XCTAssertEqual(sut.lastError, .persistenceFailed)
        XCTAssertNil(sut.createdList)
        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "list_create_failed")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "favorites")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["reason"], "persistence")
    }

    func test_create_recoversFromError_onNextSuccess() {
        repository.createBehavior = .fail(NSError(domain: "test", code: 1))
        sut.name = "Foo"
        sut.create()
        XCTAssertEqual(sut.lastError, .persistenceFailed)

        repository.createBehavior = .success
        sut.create()

        XCTAssertNil(sut.lastError)
        XCTAssertNotNil(sut.createdList)
    }

    func test_dismissError_clearsLastError() {
        repository.createBehavior = .fail(NSError(domain: "test", code: 1))
        sut.name = "Foo"
        sut.create()
        XCTAssertEqual(sut.lastError, .persistenceFailed)

        sut.dismissError()

        XCTAssertNil(sut.lastError)
    }

    func test_reset_clearsAllState() {
        sut.name = "Foo"
        sut.selectedType = .groceries
        sut.create()
        XCTAssertNotNil(sut.createdList)

        sut.reset()

        XCTAssertEqual(sut.name, "")
        XCTAssertEqual(sut.selectedType, .tasks)
        XCTAssertNil(sut.createdList)
        XCTAssertNil(sut.lastError)
    }

    func test_allListTypes_areCreatableInLessThanThreeUserActions() {
        for type in ListType.allCases {
            let local = CreateListViewModel(repository: repository, analytics: analytics)
            local.name = "Test"
            local.selectedType = type

            local.create()

            XCTAssertEqual(local.createdList?.type, type)
        }
    }
}
