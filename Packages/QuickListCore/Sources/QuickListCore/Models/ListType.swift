import Foundation

public enum ListType: String, Codable, CaseIterable, Sendable {
    case groceries
    case tasks
    case ideas
    case projects
    case favorites
}
