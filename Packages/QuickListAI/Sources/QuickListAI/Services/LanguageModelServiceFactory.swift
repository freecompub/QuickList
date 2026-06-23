import Foundation
import Logging

/// Construit l'implémentation `LanguageModelService` appropriée selon
/// l'environnement d'exécution, et expose l'`availability` détectée pour
/// que l'UI puisse masquer les entrées IA quand le modèle n'est pas dispo.
///
/// Conforme à US-19 CA1 (test d'availability au lancement) et CA2 (fallback
/// JSON local quand Apple Intelligence est indisponible).
@MainActor
public final class LanguageModelServiceFactory {
    private let logger: Logger

    public init(logger: Logger = Logger(label: "quicklist.ai.factory")) {
        self.logger = logger
    }

    public func detectAvailability() -> LanguageModelAvailability {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, macOS 26.0, *) {
            // US-19 : on s'arrête à la détection de la présence du framework
            // + version OS. La sonde fine via `SystemLanguageModel.availability`
            // (Apple Intelligence activé, device éligible) sera branchée en
            // US-07 quand on appellera réellement le modèle.
            logger.info("language_model_availability source=foundation_models")
            return .available
        } else {
            logger.info("language_model_availability source=os_too_low")
            return .unavailable(reason: .osVersionTooLow)
        }
        #else
        logger.info("language_model_availability source=framework_missing")
        return .unavailable(reason: .frameworkMissing)
        #endif
    }

    public func make() -> (service: LanguageModelService, availability: LanguageModelAvailability) {
        let availability = detectAvailability()
        let fallback = LocalRayonMappingService()
        switch availability {
        case .available:
            return (FoundationModelsLanguageService(fallback: fallback), availability)
        case .unavailable:
            return (fallback, availability)
        }
    }
}
