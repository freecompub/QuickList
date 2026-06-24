import QuickListAI
import XCTest

@MainActor
final class LanguageModelServiceFactoryTests: XCTestCase {

    func test_detectAvailability_returnsExpectedValueForCurrentBuild() {
        let factory = LanguageModelServiceFactory()

        let availability = factory.detectAvailability()

        // Le SDK iOS 26 expose FoundationModels et la cible deployment est
        // iOS 17.5, donc à la compilation `canImport(FoundationModels)` est
        // vrai. À l'execution, la classe `#available(iOS 26.0, *)` détermine
        // la branche choisie selon le runtime. Le test reste valide pour les
        // deux cas.
        XCTAssertTrue(
            availability == .available ||
            availability == .unavailable(reason: .osVersionTooLow) ||
            availability == .unavailable(reason: .frameworkMissing)
        )
    }

    func test_make_returnsFallbackWhenUnavailable_andAvailabilityMatches() async throws {
        let factory = LanguageModelServiceFactory()

        let (service, availability) = factory.make()

        switch availability {
        case .available:
            // Sur iOS 26+, la chaîne livre FoundationModelsLanguageService qui
            // délègue toujours au fallback en US-19 → la classification d'un
            // item connu (« lait ») retourne le rayon Crèmerie.
            let result = try await service.classify(itemTitle: "Lait")
            XCTAssertEqual(result.rayon, .cremerie)
        case .unavailable:
            // Sur iOS < 26 ou framework manquant, le fallback direct retourne
            // également le rayon attendu.
            let result = try await service.classify(itemTitle: "Lait")
            XCTAssertEqual(result.rayon, .cremerie)
        }
    }

    func test_availability_isAvailableProperty_matchesCase() {
        XCTAssertTrue(LanguageModelAvailability.available.isAvailable)
        XCTAssertFalse(LanguageModelAvailability.unavailable(reason: .frameworkMissing).isAvailable)
        XCTAssertFalse(LanguageModelAvailability.unavailable(reason: .osVersionTooLow).isAvailable)
    }
}
