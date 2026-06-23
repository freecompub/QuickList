import Foundation
import QuickListCore

/// Groupe d'items affichés sous le même rayon dans `ListDetailView` quand la
/// liste est de type Courses. Utilisé par le regroupement US-07 et le mode
/// Courses US-08.
struct RayonGroup {
    let title: String
    let items: [ListItem]
}
