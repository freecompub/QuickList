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
    private let classificationCoordinator: RayonClassificationCoordinator?

    public init(
        list: TaskList,
        repository: ListItemRepository,
        analytics: AnalyticsService,
        classificationCoordinator: RayonClassificationCoordinator? = nil,
        logger: Logger = Logger(label: "quicklist.add")
    ) {
        self.list = list
        self.repository = repository
        self.analytics = analytics
        self.classificationCoordinator = classificationCoordinator
        self.logger = logger
    }

    public var canSubmit: Bool {
        !pendingTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public func submit() {
        let trimmed = pendingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        do {
            let item = try repository.create(title: trimmed, in: list)
            pendingTitle = ""
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: "item_added",
                properties: ["list_type": list.type.rawValue]
            ))
            scheduleClassification(of: item)
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

    /// US-07 : la classification du rayon est asynchrone et "fire-and-forget"
    /// pour ne JAMAIS retarder l'ajout (CA `item apparait immediatement`).
    /// `scheduleClassification` exécute le coordinator dans une `Task` que
    /// le ViewModel n'attend pas — l'UI verra la `item.category` mise a jour
    /// via la `@Query` SwiftData. Si la liste n'est pas de type `.groceries`,
    /// le coordinator no-op silencieusement.
    private func scheduleClassification(of item: ListItem) {
        guard let coordinator = classificationCoordinator else { return }
        let listSnapshot = list
        // Capture forte volontaire de `coordinator` : le Task doit pouvoir
        // terminer la classification meme si l'utilisateur ferme la
        // ListDetailView avant que le modele ait repondu, sinon
        // `item.category` reste `nil` et l'item est silencieusement perdu
        // dans la rubrique "non classes" (cf. CA US-15).
        Task {
            await coordinator.classify(item, in: listSnapshot)
        }
    }
}
