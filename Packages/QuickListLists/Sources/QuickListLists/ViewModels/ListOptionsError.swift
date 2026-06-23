import Foundation

public enum ListOptionsError: Error, Equatable, Sendable {
    case renameFailed
    case deleteFailed
    case emptyName
}
