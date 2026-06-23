import Foundation
import Logging
import QuickListAnalytics
import QuickListCore

@MainActor
public final class AddItemViewModel: ObservableObject {
    @Published public var pendingTitle: String = ""
    @Published public private(set) var lastError: AddItemError?

    public let list: TaskList
    private let repository: ListItemRepository
    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        list: TaskList,
        repository: ListItemRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.add")
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
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: "item_added",
                properties: ["list_type": list.type.rawValue]
            ))
        } catch {
            logger.error("add_item_failed reason=\(String(describing: error))")
            lastError = .persistenceFailed
            analytics.track(AnalyticsEvent(
                name: "item_add_failed",
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

    /// Filtre les items SwiftData appartenant à la liste portée par ce ViewModel.
    /// Le filtrage est volontairement côté Swift (et non via `#Predicate`) pour
    /// rester compatible avec le runtime iOS 17.0-17.4 — cf. ADR-002.
    public func itemsBelongingToList(in items: [ListItem]) -> [ListItem] {
        let listID = list.persistentModelID
        return items.filter { $0.list?.persistentModelID == listID }
    }
}
