import Foundation
import Logging
import QuickListAnalytics
import QuickListCore

@MainActor
public final class AddItemViewModel: ObservableObject {
    @Published public var pendingTitle: String = ""

    private let list: TaskList
    private let repository: ListItemRepository
    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        list: TaskList,
        repository: ListItemRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.quick-add")
    ) {
        self.list = list
        self.repository = repository
        self.analytics = analytics
        self.logger = logger
    }

    public var canSubmit: Bool {
        !pendingTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public func submit() {
        let trimmed = pendingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        do {
            _ = try repository.create(title: trimmed, in: list)
            pendingTitle = ""
            analytics.track(AnalyticsEvent(
                name: "item_added",
                properties: ["list_type": list.type.rawValue]
            ))
        } catch {
            logger.error("add_item_failed reason=\(String(describing: error))")
        }
    }
}
