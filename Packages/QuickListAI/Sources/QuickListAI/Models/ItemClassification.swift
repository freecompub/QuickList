import Foundation

public struct ItemClassification: Equatable, Sendable {
    public let rayon: Rayon
    public let confidence: Double

    public init(rayon: Rayon, confidence: Double = 1.0) {
        self.rayon = rayon
        self.confidence = confidence
    }
}
