import Foundation

/// Rayons standards QuickList — alignés sur le `@Guide(.anyOf(...))` du
/// modèle Foundation Models documenté dans
/// `docs/UserStories/QuickList_user_stories.md` § Foundation Models.
public enum Rayon: String, CaseIterable, Equatable, Sendable {
    case fruitsLegumes = "Fruits & Légumes"
    case boucherie = "Boucherie"
    case cremerie = "Crèmerie"
    case epicerie = "Épicerie"
    case surgeles = "Surgelés"
    case boulangerie = "Boulangerie"
    case boissons = "Boissons"
    case hygiene = "Hygiène"
    case autres = "Autres"

    public init(rawString: String) {
        if let exact = Rayon(rawValue: rawString) {
            self = exact
        } else {
            self = .autres
        }
    }
}
