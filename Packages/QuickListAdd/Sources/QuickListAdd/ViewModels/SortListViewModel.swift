import Foundation
import Logging
import QuickListAnalytics
import QuickListCore

@MainActor
public final class SortListViewModel: ObservableObject {
    public let list: TaskList
    @Published public private(set) var lastError: SortListError?

    private let repository: TaskListRepository
    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        list: TaskList,
        repository: TaskListRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.add.sort")
    ) {
        self.list = list
        self.repository = repository
        self.analytics = analytics
        self.logger = logger
    }

    public var currentSortMode: SortMode {
        list.sortMode
    }

    public func setSortMode(_ mode: SortMode) {
        guard mode != list.sortMode else { return }
        do {
            try repository.updateSortMode(list, to: mode)
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: "list_sort_changed",
                properties: [
                    "list_type": list.type.rawValue,
                    "sort_mode": mode.rawValue
                ]
            ))
        } catch {
            logger.error("update_sort_mode_failed reason=\(String(describing: error))")
            lastError = .persistenceFailed
            analytics.track(AnalyticsEvent(
                name: "list_sort_change_failed",
                properties: [
                    "list_type": list.type.rawValue,
                    "reason": "persistence"
                ]
            ))
        }
    }

    public func sortedItems(_ items: [ListItem]) -> [ListItem] {
        switch list.sortMode {
        case .dateAdded:
            return items.sorted { $0.createdAt < $1.createdAt }
        case .alphabetical:
            return items.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .status:
            return items.sorted(by: statusComparator)
        }
    }

    public func dismissError() {
        lastError = nil
    }

    private func statusComparator(_ lhs: ListItem, _ rhs: ListItem) -> Bool {
        if lhs.isDone != rhs.isDone {
            return !lhs.isDone
        }
        return lhs.createdAt < rhs.createdAt
    }
}
