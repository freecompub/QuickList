import Foundation
import QuickListAnalytics

final class SpyAnalyticsService: AnalyticsService, @unchecked Sendable {
    private let queue = DispatchQueue(label: "spy.analytics")
    private var storedEvents: [AnalyticsEvent] = []

    var trackedEvents: [AnalyticsEvent] {
        queue.sync { storedEvents }
    }

    func track(_ event: AnalyticsEvent) {
        queue.sync { storedEvents.append(event) }
    }
}
