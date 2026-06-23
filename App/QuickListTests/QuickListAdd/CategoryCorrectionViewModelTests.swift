import QuickListAdd
import QuickListAI
import QuickListAnalytics
import QuickListCore
import XCTest

@MainActor
final class CategoryCorrectionViewModelTests: XCTestCase {

    private var list: TaskList!
    private var itemRepository: MockListItemRepository!
    private var preferenceRepository: MockCategoryPreferenceRepository!
    private var analytics: SpyAnalyticsService!
    private var sut: CategoryCorrectionViewModel!

    override func setUp() {
        super.setUp()
        list = TaskList(name: "Courses", type: .groceries)
        itemRepository = MockListItemRepository()
        preferenceRepository = MockCategoryPreferenceRepository()
        analytics = SpyAnalyticsService()
        sut = CategoryCorrectionViewModel(
            list: list,
            itemRepository: itemRepository,
            preferenceRepository: preferenceRepository,
            analytics: analytics
        )
    }

    override func tearDown() {
        sut = nil
        analytics = nil
        preferenceRepository = nil
        itemRepository = nil
        list = nil
        super.tearDown()
    }

    private func makeItem(_ title: String = "Lait") -> ListItem {
        let item = ListItem(title: title)
        item.list = list
        return item
    }

    func test_setRayon_updatesItemCategoryAndUpsertsPreference() {
        let item = makeItem("Lait entier")

        sut.setRayon(.cremerie, for: item)

        XCTAssertEqual(itemRepository.categoryUpdates.count, 1)
        XCTAssertEqual(itemRepository.categoryUpdates.first?.1, "Crèmerie")
        XCTAssertEqual(item.category, "Crèmerie")
        XCTAssertEqual(preferenceRepository.upsertCalls.count, 1)
        XCTAssertEqual(preferenceRepository.upsertCalls.first?.0, "lait entier")
        XCTAssertEqual(preferenceRepository.upsertCalls.first?.1, "Crèmerie")
    }

    func test_setRayon_emitsItemCategoryCorrectedAnalytics() {
        let item = makeItem("Pain")

        sut.setRayon(.boulangerie, for: item)

        XCTAssertEqual(analytics.trackedEvents.count, 1)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_category_corrected")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["list_type"], "groceries")
        XCTAssertEqual(analytics.trackedEvents.first?.properties["rayon"], "Boulangerie")
    }

    func test_setRayon_itemRepositoryFailure_setsErrorAndEmitsFailureAnalytics() {
        itemRepository.updateCategoryBehavior = .fail(NSError(domain: "test", code: 1))
        let item = makeItem()

        sut.setRayon(.epicerie, for: item)

        XCTAssertEqual(sut.lastError, .persistenceFailed)
        XCTAssertTrue(preferenceRepository.upsertCalls.isEmpty)
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_category_correction_failed")
    }

    func test_setRayon_preferenceRepositoryFailure_setsErrorAndKeepsItemUpdate() {
        preferenceRepository.upsertBehavior = .fail(NSError(domain: "test", code: 1))
        let item = makeItem()

        sut.setRayon(.epicerie, for: item)

        XCTAssertEqual(sut.lastError, .persistenceFailed)
        // L'update du item est passe (avant le upsert), comportement assume.
        XCTAssertEqual(item.category, "Épicerie")
        XCTAssertEqual(analytics.trackedEvents.first?.name, "item_category_correction_failed")
    }

    func test_setRayon_clearsPreviousErrorOnSuccess() {
        itemRepository.updateCategoryBehavior = .fail(NSError(domain: "test", code: 1))
        sut.setRayon(.epicerie, for: makeItem())
        XCTAssertEqual(sut.lastError, .persistenceFailed)

        itemRepository.updateCategoryBehavior = .success
        sut.setRayon(.cremerie, for: makeItem("Beurre"))

        XCTAssertNil(sut.lastError)
    }

    func test_dismissError_clearsLastError() {
        itemRepository.updateCategoryBehavior = .fail(NSError(domain: "test", code: 1))
        sut.setRayon(.epicerie, for: makeItem())
        XCTAssertEqual(sut.lastError, .persistenceFailed)

        sut.dismissError()

        XCTAssertNil(sut.lastError)
    }

    func test_setRayon_normalizesItemTitleBeforeUpserting() {
        let item = makeItem("PAIN de Mie")

        sut.setRayon(.boulangerie, for: item)

        XCTAssertEqual(preferenceRepository.upsertCalls.first?.0, "pain de mie")
    }
}
