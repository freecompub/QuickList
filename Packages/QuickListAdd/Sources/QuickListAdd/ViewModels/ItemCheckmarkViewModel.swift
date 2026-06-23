import Foundation
import Logging
import QuickListAnalytics
import QuickListCore

@MainActor
public final class ItemCheckmarkViewModel: ObservableObject {
    @Published public private(set) var lastError: ItemCheckmarkError?

    public let list: TaskList
    private let repository: ListItemRepository
    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        list: TaskList,
        repository: ListItemRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.add.checkmark")
    ) {
        self.list = list
        self.repository = repository
        self.analytics = analytics
        self.logger = logger
    }

    public func toggle(_ item: ListItem) {
        let willBeDone = !item.isDone
        do {
            try repository.toggleDone(item)
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: willBeDone ? "item_checked" : "item_unchecked",
                properties: ["list_type": list.type.rawValue]
            ))
        } catch {
            logger.error("toggle_item_done_failed reason=\(String(describing: error))")
            lastError = .persistenceFailed
            analytics.track(AnalyticsEvent(
                name: "item_toggle_done_failed",
                properties: [
                    "list_type": list.type.rawValue,
                    "reason": "persistence"
                ]
            ))
        }
    }

    public func dismissError() {
        lastError = nil
    }
}
