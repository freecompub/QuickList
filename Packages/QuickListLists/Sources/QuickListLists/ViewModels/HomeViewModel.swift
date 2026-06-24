import Foundation
import QuickListAnalytics
import QuickListCore
import QuickListDesignSystem

@MainActor
public final class HomeViewModel: ObservableObject {

    private let analytics: AnalyticsService

    public init(analytics: AnalyticsService) {
        self.analytics = analytics
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
        list.type.presentation
    }

    public func listDidOpen(_ list: TaskList) {
        analytics.track(AnalyticsEvent(
            name: "list_opened",
            properties: ["list_type": list.type.rawValue]
        ))
    }
}
