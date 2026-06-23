import Foundation
import QuickListCore
import SwiftData

@MainActor
final class MockCategoryPreferenceRepository: CategoryPreferenceRepository {
    enum Behavior {
        case success
        case fail(Error)
    }

    var lookupBehavior: Behavior = .success
    var upsertBehavior: Behavior = .success

    private(set) var lookupCalls: [String] = []
    private(set) var upsertCalls: [(String, String)] = []
    var storedPreferences: [String: String] = [:]
    private let container: ModelContainer
    private let context: ModelContext

    init() {
        let schema = Schema([CategoryPreference.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        // Force in-memory model container — required by SwiftData to back any
        // CategoryPreference instance returned via `lookup`.
        guard let container = try? ModelContainer(for: schema, configurations: [config]) else {
            fatalError("Could not initialize CategoryPreference in-memory store")
        }
        self.container = container
        self.context = ModelContext(container)
    }

    func lookup(normalizedName: String) throws -> CategoryPreference? {
        lookupCalls.append(normalizedName)
        switch lookupBehavior {
        case .success:
            guard let category = storedPreferences[normalizedName] else { return nil }
            let preference = CategoryPreference(normalizedName: normalizedName, category: category)
            context.insert(preference)
            return preference
        case .fail(let error):
            throw error
        }
    }

    func upsert(normalizedName: String, category: String) throws {
        upsertCalls.append((normalizedName, category))
        switch upsertBehavior {
        case .success:
            storedPreferences[normalizedName] = category
        case .fail(let error):
            throw error
        }
    }
}
