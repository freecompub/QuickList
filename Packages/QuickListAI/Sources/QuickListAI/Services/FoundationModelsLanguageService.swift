import Foundation
import Logging

#if canImport(FoundationModels)
import FoundationModels
#endif

/// Implémentation `LanguageModelService` adossée à `FoundationModels`
/// (Apple Intelligence on-device, iOS 26+).
///
/// Pour US-19 : squelette qui contrôle l'availability et délègue au fallback
/// si Apple Intelligence n'est pas disponible. La logique de prompt @Generable
/// (cf. spec `docs/UserStories/QuickList_user_stories.md` § Foundation Models)
/// sera branchée en US-07 / US-15 / US-16.
public final class FoundationModelsLanguageService: LanguageModelService {
    private let fallback: LanguageModelService
    private let logger: Logger

    public init(
        fallback: LanguageModelService,
        logger: Logger = Logger(label: "quicklist.ai.foundation-models")
    ) {
        self.fallback = fallback
        self.logger = logger
    }

    public func classify(itemTitle: String) async throws -> ItemClassification {
        // US-19 : on n'invoque pas encore `LanguageModelSession.respond(...)`.
        // Le délégué au fallback couvre 100 % des cas pour cette US. Le call site
        // Foundation Models sera ajouté en US-07 sous `@available(iOS 26.0, *)`.
        logger.debug("classify_via_fallback title_length=\(itemTitle.count)")
        return try await fallback.classify(itemTitle: itemTitle)
    }
}
