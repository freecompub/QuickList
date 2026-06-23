import Foundation

public enum LanguageModelAvailability: Equatable, Sendable {
    case available
    case unavailable(reason: UnavailabilityReason)

    public enum UnavailabilityReason: String, Equatable, Sendable {
        case frameworkMissing
        case osVersionTooLow
        case appleIntelligenceDisabled
        case deviceNotEligible
        case unknown
    }

    public var isAvailable: Bool {
        if case .available = self { return true }
        return false
    }
}
