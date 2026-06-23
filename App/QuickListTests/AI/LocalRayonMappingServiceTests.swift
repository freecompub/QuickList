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

    func test_classify_handlesAccents_returnsEpicerie() async throws {
        let classification = try await sut.classify(itemTitle: "Pâtes")

        XCTAssertEqual(classification.rayon, .epicerie)
    }

    func test_classify_collisionCafeFroid_returnsBoissons() async throws {
        let classification = try await sut.classify(itemTitle: "Café froid")

        // "café froid" est plus long et plus spécifique que "café" (Épicerie),
        // donc il doit l'emporter et matcher Boissons.
        XCTAssertEqual(classification.rayon, .boissons)
    }

    func test_classify_collisionPommeDeTerre_returnsFruitsLegumes() async throws {
        let classification = try await sut.classify(itemTitle: "Pomme de terre")

        // Les deux keywords renvoient Fruits & Légumes : test garantit la
        // déterminisme (pas de plantage par doublon) en plus du resultat metier.
        XCTAssertEqual(classification.rayon, .fruitsLegumes)
    }

    func test_classify_isDeterministic_overRepeatedRuns() async throws {
        let inputs = ["Pomme de terre", "Café froid", "Lait demi-écrémé", "Eau gazeuse"]
        var firstRun: [String: Rayon] = [:]
        for title in inputs {
            firstRun[title] = try await sut.classify(itemTitle: title).rayon
        }
        for _ in 0..<10 {
            for title in inputs {
                let result = try await sut.classify(itemTitle: title).rayon
                XCTAssertEqual(result, firstRun[title], "Inconsistent classification for \(title)")
            }
        }
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
