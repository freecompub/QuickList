import QuickListAdd
import QuickListAI
import QuickListAnalytics
import QuickListCore
import XCTest

@MainActor
final class RayonClassificationCoordinatorTests: XCTestCase {

    private var repository: MockListItemRepository!
    private var analytics: SpyAnalyticsService!
    private var service: MockLanguageModelService!
    private var sut: RayonClassificationCoordinator!

    override func setUp() {
        super.setUp()
        repository = MockListItemRepository()
        analytics = SpyAnalyticsService()
        service = MockLanguageModelService()
        sut = RayonClassificationCoordinator(
            service: service,
            repository: repository,
            analytics: analytics
        )
    }

    override func tearDown() {
        sut = nil
        service = nil
        analytics = nil
        repository = nil
        super.tearDown()
    }

    func test_classify_nonGroceriesList_isNoOp() async {
        let list = TaskList(name: "Tâches", type: .tasks)
        let item = ListItem(title: "Acheter du lait")

        let rayon = await sut.classify(item, in: list)

        XCTAssertNil(rayon)
        XCTAssertTrue(service.classifyRequests.isEmpty)
        XCTAssertTrue(repository.categoryUpdates.isEmpty)
        XCTAssertTrue(analytics.trackedEvents.isEmpty)
    }

    func test_classify_groceriesList_callsServiceAndPersistsCategory() async {
        let list = TaskList(name: "Courses", type: .groceries)
        let item = ListItem(title: "Lait entier")
        service.behavior = .success(.cremerie)

        let rayon = await sut.classify(item, in: list)

        XCTAssertEqual(rayon, .cremerie)
        XCTAssertEqual(service.classifyRequests, ["Lait entier"])
        XCTAssertEqual(repository.categoryUpdates.count, 1)
        XCTAssertEqual(repository.categoryUpdates.first?.1, "Crèmerie")
        XCTAssertEqual(item.category, "Crèmerie")
    }

    func test_classify_emitsItemClassifiedAnalytics() async {
        let list = TaskList(name: "Courses", type: .groceries)
        let item = ListItem(title: "Pain")
        service.behavior = .success(.boulangerie)

        _ = await sut.classify(item, in: list)

        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_classified")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "groceries")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["rayon"], "Boulangerie")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["matched"], "true")
    }

    func test_classify_autres_emitsMatchedFalse() async {
        let list = TaskList(name: "Courses", type: .groceries)
        let item = ListItem(title: "Truc inconnu")
        service.behavior = .success(.autres)

        _ = await sut.classify(item, in: list)

        XCTAssertEqual(analytics.trackedEvents.first?.properties["rayon"], "Autres")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["matched"], "false")
    }

    func test_classify_serviceFailure_setsCategoryNotPersistedAndEmitsFailureAnalytics() async {
        let list = TaskList(name: "Courses", type: .groceries)
        let item = ListItem(title: "Lait")
        service.behavior = .fail(NSError(domain: "test", code: 1))

        let rayon = await sut.classify(item, in: list)

        XCTAssertNil(rayon)
        XCTAssertTrue(repository.categoryUpdates.isEmpty)
        XCTAssertNil(item.category)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_classify_failed")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "groceries")
    }

    func test_classify_repositoryFailure_doesNotEmitClassified() async {
        let list = TaskList(name: "Courses", type: .groceries)
        let item = ListItem(title: "Lait")
        service.behavior = .success(.cremerie)
        repository.updateCategoryBehavior = .fail(NSError(domain: "test", code: 2))

        let rayon = await sut.classify(item, in: list)

        XCTAssertNil(rayon)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_classify_failed")
    }
}
