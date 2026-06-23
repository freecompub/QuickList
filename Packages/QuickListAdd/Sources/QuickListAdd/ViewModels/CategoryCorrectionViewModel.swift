import Foundation
import Logging
import QuickListAI
import QuickListAnalytics
import QuickListCore

@MainActor
public final class CategoryCorrectionViewModel: ObservableObject {
    @Published public private(set) var lastError: CategoryCorrectionError?

    public let list: TaskList
    private let itemRepository: ListItemRepository
    private let preferenceRepository: CategoryPreferenceRepository
    private let analytics: AnalyticsService
    private let logger: Logger

    public init(
        list: TaskList,
        itemRepository: ListItemRepository,
        preferenceRepository: CategoryPreferenceRepository,
        analytics: AnalyticsService,
        logger: Logger = Logger(label: "quicklist.add.category-correction")
    ) {
        self.list = list
        self.itemRepository = itemRepository
        self.preferenceRepository = preferenceRepository
        self.analytics = analytics
        self.logger = logger
    }

    /// Applique une correction utilisateur : met à jour `item.category` et
    /// mémorise la préférence dans `CategoryPreference` pour qu'elle ait
    /// priorité lors des prochains ajouts du même article.
    public func setRayon(_ rayon: Rayon, for item: ListItem) {
        do {
            try itemRepository.updateCategory(item, to: rayon.rawValue)
            let normalized = LocalRayonMappingService.normalize(item.title)
            try preferenceRepository.upsert(normalizedName: normalized, category: rayon.rawValue)
            lastError = nil
            analytics.track(AnalyticsEvent(
                name: "item_category_corrected",
                properties: [
                    "list_type": list.type.rawValue,
                    "rayon": rayon.rawValue
                ]
            ))
        } catch {
            logger.error("category_correction_failed reason=\(String(describing: error))")
            lastError = .persistenceFailed
            analytics.track(AnalyticsEvent(
                name: "item_category_correction_failed",
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
