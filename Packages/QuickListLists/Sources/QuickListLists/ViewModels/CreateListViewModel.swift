import Foundation
import Logging
import QuickListAnalytics
import QuickListCore

@MainActor
public final class CreateListViewModel: ObservableObject {
    @Published public var name: String = ""
    @Published public var selectedType: ListType = .tasks
    @Published public private(set) var lastError: CreateListError?
    @Published public private(set) var createdList: TaskList?
    /// Conservé pour préparer l'async US-04+. Aujourd'hui `create()` est
    /// synchrone donc le flag bascule à `true` puis `false` dans le même tick
    /// runloop ; la garde idempotente repose principalement sur `createdList`.
    @Published public private(set) var isCreating: Bool = false

    private let repository: TaskListRepository
    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        repository: TaskListRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.lists.create")
    ) {
        self.repository = repository
        self.analytics = analytics
        self.logger = logger
    }

    public var canCreate: Bool {
        guard !isCreating, createdList == nil else { return false }
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public func create() {
        // Garde-fou idempotent : un double-tap rapide sur "Créer" ne doit
        // pas persister deux listes ni émettre deux events `list_created`.
        guard !isCreating, createdList == nil else { return }
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isCreating = true
        defer { isCreating = false }
        do {
            let list = try repository.create(name: trimmed, type: selectedType)
            createdList = list
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: "list_created",
                properties: ["list_type": selectedType.rawValue]
            ))
        } catch {
            logger.error("create_list_failed reason=\(String(describing: error))")
            lastError = .persistenceFailed
            analytics.track(AnalyticsEvent(
                name: "list_create_failed",
                properties: [
                    "list_type": selectedType.rawValue,
                    "reason": "persistence"
                ]
            ))
        }
    }

    public func dismissError() {
        lastError = nil
    }

    public func reset() {
        name = ""
        selectedType = .tasks
        createdList = nil
        lastError = nil
        isCreating = false
    }
}
