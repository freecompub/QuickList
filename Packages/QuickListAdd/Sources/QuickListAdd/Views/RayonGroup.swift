import Foundation
import QuickListAI
import QuickListCore
import QuickListDesignSystem

/// Groupe d'items affichés sous le même rayon dans `ListDetailView` quand la
/// liste est de type Courses. Utilisé par le regroupement US-07 et le mode
/// Courses US-08.
struct RayonGroup {
    let title: String
    let items: [ListItem]
}

extension RayonGroup {
    /// Regroupe une liste d'items par leur `category` SwiftData. Les items
    /// non classés (`item.category == nil`) ou explicitement classés
    /// `Autres` tombent dans une section dédiée en fin de liste.
    static func grouped(_ items: [ListItem]) -> [RayonGroup] {
        // Cle technique stable : le rawValue du modele (FR), utilisee aussi
        // bien pour les items non classes que pour ceux explicitement
        // classes "Autres" par le service.
        let autresKey = Rayon.autres.rawValue
        var bucketsByKey: [String: [ListItem]] = [:]
        var order: [String] = []
        for item in items {
            let key = item.category ?? autresKey
            if bucketsByKey[key] == nil {
                bucketsByKey[key] = []
                order.append(key)
            }
            bucketsByKey[key]?.append(item)
        }
        if let autres = bucketsByKey.removeValue(forKey: autresKey) {
            order.removeAll { $0 == autresKey }
            order.append(autresKey)
            bucketsByKey[autresKey] = autres
        }
        return order.compactMap { key in
            guard let bucketItems = bucketsByKey[key] else { return nil }
            let title = (key == autresKey) ? QuickListStrings.rayonAutres : key
            return RayonGroup(title: title, items: bucketItems)
        }
    }
}
