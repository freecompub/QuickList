import QuickListAI
import XCTest

final class LocalRayonMappingServiceTests: XCTestCase {

    private var sut: LocalRayonMappingService!

    override func setUp() {
        super.setUp()
        sut = LocalRayonMappingService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_classify_emptyTitle_returnsAutres() async throws {
        let classification = try await sut.classify(itemTitle: "  ")

        XCTAssertEqual(classification.rayon, .autres)
        XCTAssertEqual(classification.confidence, 0)
    }

    func test_classify_unknownItem_returnsAutres() async throws {
        let classification = try await sut.classify(itemTitle: "Quelque chose d'inconnu")

        XCTAssertEqual(classification.rayon, .autres)
    }

    func test_classify_milk_returnsCremerie() async throws {
        let classification = try await sut.classify(itemTitle: "Lait")

        XCTAssertEqual(classification.rayon, .cremerie)
        XCTAssertEqual(classification.confidence, 1.0)
    }

    func test_classify_caseInsensitive_returnsCremerie() async throws {
        let classification = try await sut.classify(itemTitle: "LAIT entier")

        XCTAssertEqual(classification.rayon, .cremerie)
    }

    func test_classify_handlesAccents_returnsBoulangerie() async throws {
        let classification = try await sut.classify(itemTitle: "Pâtes")

        XCTAssertEqual(classification.rayon, .epicerie)
    }

    func test_classify_bread_returnsBoulangerie() async throws {
        let classification = try await sut.classify(itemTitle: "Pain de mie")

        XCTAssertEqual(classification.rayon, .boulangerie)
    }

    func test_classify_water_returnsBoissons() async throws {
        let classification = try await sut.classify(itemTitle: "Eau gazeuse")

        XCTAssertEqual(classification.rayon, .boissons)
    }

    func test_classify_meat_returnsBoucherie() async throws {
        let classification = try await sut.classify(itemTitle: "Steak haché")

        XCTAssertEqual(classification.rayon, .boucherie)
    }

    func test_classify_customMapping_overridesBundle() async throws {
        let custom = LocalRayonMappingService(mapping: ["xenon": .epicerie])
        let classification = try await custom.classify(itemTitle: "xenon")

        XCTAssertEqual(classification.rayon, .epicerie)
    }

    func test_normalize_lowercasesAndStripsDiacritics() {
        XCTAssertEqual(LocalRayonMappingService.normalize("PÂTÉ"), "pate")
    }
}
