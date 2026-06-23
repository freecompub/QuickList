import Foundation
import SwiftData

@MainActor
public final class SwiftDataCategoryPreferenceRepository: CategoryPreferenceRepository {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func lookup(normalizedName: String) throws -> CategoryPreference? {
        let descriptor = FetchDescriptor<CategoryPreference>()
        let all = try context.fetch(descriptor)
        return all.first { $0.normalizedName == normalizedName }
    }

    /// Helper interne pour les tests : compte le nombre d'entrees persistees.
    /// Permet de verifier l'unicite apres upsert sans exposer le context.
    public func countAll() throws -> Int {
        try context.fetchCount(FetchDescriptor<CategoryPreference>())
    }

    public func upsert(normalizedName: String, category: String) throws {
        let trimmed = normalizedName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if let existing = try lookup(normalizedName: trimmed) {
            existing.category = category
        } else {
            let preference = CategoryPreference(normalizedName: trimmed, category: category)
            context.insert(preference)
        }
        try context.save()
    }
}
