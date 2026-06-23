import QuickListAI
import QuickListAnalytics
import QuickListCore
import SwiftData
import SwiftUI

@main
struct QuickListApp: App {
    private let container: ModelContainer
    private let languageModelService: LanguageModelService
    private let languageModelAvailability: LanguageModelAvailability

    @MainActor
    init() {
        do {
            let schema = Schema([TaskList.self, ListItem.self])
            let configuration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
        // US-19 CA1 + US-07 : la chaîne LanguageModelService est créée une
        // seule fois au lancement, partagée entre toutes les surfaces. Évite
        // une double-sonde si RootView est re-évaluée par SwiftUI.
        let factory = LanguageModelServiceFactory()
        let (service, availability) = factory.make()
        languageModelService = service
        languageModelAvailability = availability
        QuickListApp.reportLanguageModelAvailability(availability)
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                languageModelService: languageModelService,
                languageModelAvailability: languageModelAvailability
            )
        }
        .modelContainer(container)
    }

    /// US-19 CA1 : journalise la disponibilité d'Apple Intelligence au
    /// lancement via le module Analytics. La sonde fine via
    /// `SystemLanguageModel.availability` (Apple Intelligence activé, device
    /// éligible) reste à brancher en US-15 — cf. OPEN-QUESTIONS § AI-AVAIL-FINE.
    @MainActor
    private static func reportLanguageModelAvailability(_ availability: LanguageModelAvailability) {
        let analytics: AnalyticsService = LoggingAnalyticsService()
        var properties: [String: String] = [
            "is_available": availability.isAvailable ? "true" : "false"
        ]
        if case .unavailable(let reason) = availability {
            properties["reason"] = reason.rawValue
        }
        analytics.track(AnalyticsEvent(
            name: "language_model_availability_detected",
            properties: properties
        ))
    }
}
