import Foundation
import Logging

public final class LocalRayonMappingService: LanguageModelService, @unchecked Sendable {
    private let mapping: [String: Rayon]
    private let logger: Logger

    public init(
        mapping: [String: Rayon]? = nil,
        logger: Logger = Logger(label: "quicklist.ai.local-mapping")
    ) {
        if let mapping {
            self.mapping = mapping
        } else {
            self.mapping = LocalRayonMappingService.loadBundledMapping(logger: logger)
        }
        self.logger = logger
    }

    public func classify(itemTitle: String) async throws -> ItemClassification {
        let normalized = LocalRayonMappingService.normalize(itemTitle)
        guard !normalized.isEmpty else {
            return ItemClassification(rayon: .autres, confidence: 0)
        }
        for (keyword, rayon) in mapping where normalized.contains(keyword) {
            return ItemClassification(rayon: rayon, confidence: 1.0)
        }
        return ItemClassification(rayon: .autres, confidence: 0)
    }

    public static func normalize(_ raw: String) -> String {
        let lowered = raw.lowercased()
        guard let folded = lowered.applyingTransform(.stripDiacritics, reverse: false) else {
            return lowered.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return folded.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func loadBundledMapping(logger: Logger) -> [String: Rayon] {
        guard let url = Bundle.module.url(forResource: "rayon_mapping", withExtension: "json") else {
            logger.warning("rayon_mapping_resource_missing")
            return [:]
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [String]].self, from: data)
            var mapping: [String: Rayon] = [:]
            for (rayonName, keywords) in decoded {
                let rayon = Rayon(rawString: rayonName)
                for keyword in keywords {
                    let normalized = LocalRayonMappingService.normalize(keyword)
                    if !normalized.isEmpty {
                        mapping[normalized] = rayon
                    }
                }
            }
            return mapping
        } catch {
            logger.error("rayon_mapping_decode_failed reason=\(String(describing: error))")
            return [:]
        }
    }
}
