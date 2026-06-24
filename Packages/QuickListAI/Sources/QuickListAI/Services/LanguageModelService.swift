import Foundation

public protocol LanguageModelService: Sendable {
    /// Classifie un titre d'item dans un `Rayon`. Asynchrone pour ne jamais
    /// bloquer le main thread — même la version déterministe locale respecte
    /// le contrat async pour éviter qu'un swap d'impl ne casse les call sites.
    func classify(itemTitle: String) async throws -> ItemClassification
}
