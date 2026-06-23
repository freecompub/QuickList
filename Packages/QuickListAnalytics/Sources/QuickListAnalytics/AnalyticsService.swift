import Foundation

public protocol AnalyticsService: AnyObject, Sendable {
    func track(_ event: AnalyticsEvent)
}
