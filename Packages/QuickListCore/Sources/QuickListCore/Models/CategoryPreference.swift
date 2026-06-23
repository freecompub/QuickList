import Foundation
import SwiftData

@Model
public final class CategoryPreference {
    public var normalizedName: String = ""
    public var category: String = ""
    public var createdAt: Date = Date()

    public init(normalizedName: String, category: String) {
        self.normalizedName = normalizedName
        self.category = category
    }
}
