import Foundation

@MainActor
public protocol CategoryPreferenceRepository: AnyObject {
    func lookup(normalizedName: String) throws -> CategoryPreference?
    func upsert(normalizedName: String, category: String) throws
}
