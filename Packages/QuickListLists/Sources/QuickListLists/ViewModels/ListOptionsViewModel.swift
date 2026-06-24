import Foundation
import Logging
import QuickListAnalytics
import QuickListCore

@MainActor
public final class ListOptionsViewModel: ObservableObject {
    @Published public var draftName: String
    @Published public private(set) var lastError: ListOptionsError?
    @Published public private(set) var didRename: Bool = false
    @Published public private(set) var didDelete: Bool = false

    public let list: TaskList
    private let repository: TaskListRepository
    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        list: TaskList,
        repository: TaskListRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.lists.options")
    ) {
        self.list = list
        self.repository = repository
        self.analytics = analytics
        self.logger = logger
        self.draftName = list.name
    }

    public var canRename: Bool {
        let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        return trimmed != list.name
    }

    public func rename() {
        let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            lastError = .emptyName
            return
        }
        guard trimmed != list.name else { return }
        do {
            try repository.rename(list, to: trimmed)
            didRename = true
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: "list_renamed",
                properties: ["list_type": list.type.rawValue]
            ))
        } catch {
            logger.error("rename_list_failed reason=\(String(describing: error))")
            lastError = .renameFailed
            analytics.track(AnalyticsEvent(
                name: "list_rename_failed",
                properties: [
                    "list_type": list.type.rawValue,
                    "reason": "persistence"
                ]
            ))
        }
    }

    public func delete() {
        do {
            let listType = list.type.rawValue
            try repository.delete(list)
            didDelete = true
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: "list_deleted",
                properties: ["list_type": listType]
            ))
        } catch {
            logger.error("delete_list_failed reason=\(String(describing: error))")
            lastError = .deleteFailed
            analytics.track(AnalyticsEvent(
                name: "list_delete_failed",
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

    public func acknowledgeRename() {
        didRename = false
    }

    public func acknowledgeDelete() {
        didDelete = false
    }

    public func resetDraftName() {
        draftName = list.name
    }
}
