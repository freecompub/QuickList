import Foundation
import QuickListAI

final class MockLanguageModelService: LanguageModelService, @unchecked Sendable {
    enum Behavior {
        case success(Rayon)
        case fail(Error)
    }

    var behavior: Behavior = .success(.autres)
    private let queue = DispatchQueue(label: "spy.lm-service")
    private var storedRequests: [String] = []

    var classifyRequests: [String] {
        queue.sync { storedRequests }
    }

    func classify(itemTitle: String) async throws -> ItemClassification {
        queue.sync { storedRequests.append(itemTitle) }
        switch behavior {
        case .success(let rayon):
            return ItemClassification(rayon: rayon, confidence: 1.0)
        case .fail(let error):
            throw error
        }
    }
}
