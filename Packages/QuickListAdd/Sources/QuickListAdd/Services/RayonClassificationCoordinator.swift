import Foundation
import Logging
import QuickListAI
import QuickListAnalytics
import QuickListCore

/// Orchestre la classification asynchrone d'un `ListItem` vers un rayon.
/// Conforme à US-07 :
/// - À l'ajout d'un item d'une liste de type `.groceries`, le rayon est
///   déterminé via `LanguageModelService` (Foundation Models si dispo,
///   sinon fallback JSON local — cf. US-19 / ADR-004).
/// - Article non reconnu → `item.category = "Autres"` (le service local
///   retourne déjà `Rayon.autres` dans ce cas).
/// - Le call est `async` et lancé "fire-and-forget" depuis le ViewModel
///   pour respecter la promesse de US-01 (ajout instantané, classification
///   en arrière-plan — pleinement formalisé en US-15).
@MainActor
public final class RayonClassificationCoordinator {

    private let service: LanguageModelService
    private let repository: ListItemRepository
    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        service: LanguageModelService,
        repository: ListItemRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.ai.rayon-coordinator")
    ) {
        self.service = service
        self.repository = repository
        self.analytics = analytics
        self.logger = logger
    }

    /// Classifie l'item passé. No-op silencieux si la liste n'est pas de
    /// type `.groceries` (économie de batterie, aucun appel modèle).
    /// Retourne le rayon attribué ou `nil` si la classification a été
    /// passée / échouée.
    @discardableResult
    public func classify(_ item: ListItem, in list: TaskList) async -> Rayon? {
        guard list.type == .groceries else { return nil }
        let title = item.title
        do {
            let classification = try await service.classify(itemTitle: title)
            try repository.updateCategory(item, to: classification.rayon.rawValue)
            analytics.track(AnalyticsEvent(
                name: "item_classified",
                properties: [
                    "list_type": list.type.rawValue,
                    "rayon": classification.rayon.rawValue,
                    "matched": classification.rayon == .autres ? "false" : "true"
                ]
            ))
            return classification.rayon
        } catch {
            logger.error("classify_item_failed reason=\(String(describing: error))")
            analytics.track(AnalyticsEvent(
                name: "item_classify_failed",
                properties: [
                    "list_type": list.type.rawValue,
                    "reason": "language_model"
                ]
            ))
            return nil
        }
    }
}
