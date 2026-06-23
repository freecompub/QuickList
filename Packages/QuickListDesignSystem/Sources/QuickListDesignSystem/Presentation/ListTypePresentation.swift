import SwiftUI

public enum ListTypeKind: String, CaseIterable, Hashable, Sendable {
    case groceries
    case tasks
    case ideas
    case projects
    case favorites
}

public struct ListTypePresentation {
    public let kind: ListTypeKind
    public let systemImageName: String
    public let renderingMode: SymbolRenderingMode
    public let tint: Color
    public let label: String

    public static func presentation(for kind: ListTypeKind) -> ListTypePresentation {
        switch kind {
        case .groceries:
            return ListTypePresentation(
                kind: kind,
                systemImageName: Symbol.qlListTypeGroceries,
                renderingMode: .multicolor,
                tint: .qlAccent,
                label: QuickListStrings.listTypeGroceries
            )
        case .tasks:
            return ListTypePresentation(
                kind: kind,
                systemImageName: Symbol.qlListTypeTasks,
                renderingMode: .hierarchical,
                tint: .qlPrimaryLabel,
                label: QuickListStrings.listTypeTasks
            )
        case .ideas:
            return ListTypePresentation(
                kind: kind,
                systemImageName: Symbol.qlListTypeIdeas,
                renderingMode: .multicolor,
                tint: .qlAccent,
                label: QuickListStrings.listTypeIdeas
            )
        case .projects:
            return ListTypePresentation(
                kind: kind,
                systemImageName: Symbol.qlListTypeProjects,
                renderingMode: .hierarchical,
                tint: .qlSecondaryLabel,
                label: QuickListStrings.listTypeProjects
            )
        case .favorites:
            return ListTypePresentation(
                kind: kind,
                systemImageName: Symbol.qlListTypeFavorites,
                renderingMode: .multicolor,
                tint: .qlAccent,
                label: QuickListStrings.listTypeFavorites
            )
        }
    }
}
