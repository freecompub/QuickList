import Foundation
import Logging
import QuickListAnalytics
import QuickListCore

@MainActor
public final class ListItemActionsViewModel: ObservableObject {

    public struct PendingUndo: Equatable {
        public let snapshot: ListItemSnapshot
    }

    @Published public private(set) var pendingUndo: PendingUndo?
    @Published public private(set) var lastError: ListItemActionsError?

    public let list: TaskList
    private let repository: ListItemRepository
    private let analytics: AnalyticsService
    private let logger: Logger
    private let undoTimeout: TimeInterval
    private var pendingExpiryTask: Task<Void, Never>?

    public init(
        list: TaskList,
        repository: ListItemRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.add.actions"),
        undoTimeout: TimeInterval = 4
    ) {
        self.list = list
        self.repository = repository
        self.analytics = analytics
        self.logger = logger
        self.undoTimeout = undoTimeout
    }

    public func delete(_ item: ListItem) {
        let snapshot = item.snapshot()
        do {
            try repository.delete(item)
            schedulePendingUndo(for: snapshot)
        } catch {
            logger.error("delete_item_failed reason=\(String(describing: error))")
            lastError = .deleteFailed
            analytics.track(AnalyticsEvent(
                name: "item_delete_failed",
                properties: [
                    "list_type": list.type.rawValue,
                    "reason": "persistence"
                ]
            ))
        }
    }

    public func undoLastDeletion() {
        guard let pending = pendingUndo else { return }
        pendingExpiryTask?.cancel()
        pendingExpiryTask = nil
        do {
            _ = try repository.restore(pending.snapshot, in: list)
            pendingUndo = nil
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: "item_delete_undone",
                properties: ["list_type": list.type.rawValue]
            ))
        } catch {
            logger.error("undo_delete_failed reason=\(String(describing: error))")
            lastError = .restoreFailed
            analytics.track(AnalyticsEvent(
                name: "item_delete_undo_failed",
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

    /// Confirme définitivement la suppression en attente : libère le snapshot,
    /// émet `item_deleted` et annule le timer. Appelé par le timer interne à
    /// l'expiration, et utilisable aussi pour valider explicitement (tests).
    public func commitPendingDeletion() {
        pendingExpiryTask?.cancel()
        pendingExpiryTask = nil
        guard pendingUndo != nil else { return }
        pendingUndo = nil
        analytics.track(AnalyticsEvent(
            name: "item_deleted",
            properties: ["list_type": list.type.rawValue]
        ))
    }

    private func schedulePendingUndo(for snapshot: ListItemSnapshot) {
        // Si une suppression precedente attendait son expiration, la confirmer
        // maintenant pour ne pas perdre son evenement `item_deleted` et ne pas
        // ecraser silencieusement son snapshot annulable.
        if pendingUndo != nil {
            commitPendingDeletion()
        }
        pendingUndo = PendingUndo(snapshot: snapshot)
        lastError = nil
        let timeout = undoTimeout
        pendingExpiryTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            if Task.isCancelled { return }
            await self?.commitPendingDeletion()
        }
    }
}
