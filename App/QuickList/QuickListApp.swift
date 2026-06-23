import QuickListAI
import QuickListAnalytics
import QuickListCore
import SwiftData
import SwiftUI

@main
struct QuickListApp: App {
    private let container: ModelContainer

    @MainActor
    init() {
        do {
            let schema = Schema([TaskList.self, ListItem.self])
            let configuration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
        QuickListApp.reportLanguageModelAvailability()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }

    /// US-19 CA1 : sonde la disponibilité d'Apple Intelligence au lancement
    /// et journalise via le module Analytics. La sonde fine via
    /// `SystemLanguageModel.availability` (Apple Intelligence activé, device
    /// éligible) reste à brancher en US-07 — cf. OPEN-QUESTIONS § AI-AVAIL-FINE.
    @MainActor
    private static func reportLanguageModelAvailability() {
        let factory = LanguageModelServiceFactory()
        let availability = factory.detectAvailability()
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
