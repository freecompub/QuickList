import QuickListCore
import QuickListDesignSystem

public extension ListType {
    var kind: ListTypeKind {
        switch self {
        case .groceries: return .groceries
        case .tasks: return .tasks
        case .ideas: return .ideas
        case .projects: return .projects
        case .favorites: return .favorites
        }
    }

    var presentation: ListTypePresentation {
        ListTypePresentation.presentation(for: kind)
    }
}
