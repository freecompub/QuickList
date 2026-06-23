import QuickListCore
import SwiftData
import XCTest

@MainActor
final class CategoryPreferenceRepositoryTests: XCTestCase {

    private func makeRepository() throws -> SwiftDataCategoryPreferenceRepository {
        let schema = Schema([CategoryPreference.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        return SwiftDataCategoryPreferenceRepository(context: context)
    }

    func test_lookup_returnsNilWhenEmpty() throws {
        let repo = try makeRepository()

        XCTAssertNil(try repo.lookup(normalizedName: "lait"))
    }

    func test_upsert_thenLookup_returnsValue() throws {
        let repo = try makeRepository()

        try repo.upsert(normalizedName: "lait", category: "Crèmerie")

        XCTAssertEqual(try repo.lookup(normalizedName: "lait")?.category, "Crèmerie")
    }

    func test_upsert_existingKey_replacesValueWithoutDuplicating() throws {
        let repo = try makeRepository()
        try repo.upsert(normalizedName: "lait", category: "Crèmerie")

        try repo.upsert(normalizedName: "lait", category: "Surgelés")

        XCTAssertEqual(try repo.lookup(normalizedName: "lait")?.category, "Surgelés")
        XCTAssertEqual(try repo.countAll(), 1, "Un upsert sur cle existante ne doit pas creer de doublon")
    }

    func test_upsert_emptyNormalizedName_isNoOp() throws {
        let repo = try makeRepository()

        try repo.upsert(normalizedName: "  ", category: "Boulangerie")

        XCTAssertNil(try repo.lookup(normalizedName: ""))
    }

}
