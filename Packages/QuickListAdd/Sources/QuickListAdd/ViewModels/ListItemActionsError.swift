import Foundation

public enum ListItemActionsError: Error, Equatable, Sendable {
    case deleteFailed
    case restoreFailed
}
