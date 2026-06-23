import Foundation
import Logging
import QuickListAnalytics
import QuickListCore
import QuickListDesignSystem

@MainActor
public final class HomeViewModel: ObservableObject {

    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.lists.home")
    ) {
        self.analytics = analytics
        self.logger = logger
    }

    public func unfinishedItemsCount(in list: TaskList) -> Int {
        guard let items = list.items else { return 0 }
        return items.reduce(into: 0) { partial, item in
            if !item.isDone { partial += 1 }
        }
    }

    public func totalItemsCount(in list: TaskList) -> Int {
        list.items?.count ?? 0
    }

    public func subtitle(for list: TaskList) -> String {
        QuickListStrings.itemCount(totalItemsCount(in: list))
    }

    public func presentation(for list: TaskList) -> ListTypePresentation {
        ListTypePresentation.presentation(for: kind(for: list.type))
    }

    public func listDidOpen(_ list: TaskList) {
        analytics.track(AnalyticsEvent(
            name: "list_opened",
            properties: ["list_type": list.type.rawValue]
        ))
    }

    private func kind(for type: ListType) -> ListTypeKind {
        switch type {
        case .groceries: return .groceries
        case .tasks: return .tasks
        case .ideas: return .ideas
        case .projects: return .projects
        case .favorites: return .favorites
        }
    }
}
