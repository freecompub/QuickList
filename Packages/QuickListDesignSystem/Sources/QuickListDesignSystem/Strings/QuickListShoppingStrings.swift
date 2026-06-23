import Foundation

public extension QuickListStrings {
    static let itemToggleAccessibilityToDo = String(
        localized: "ql.item.toggle.accessibility.toDo",
        bundle: .module,
        comment: "Accessibility hint for the tap target that marks an item as done."
    )

    static let itemToggleAccessibilityDone = String(
        localized: "ql.item.toggle.accessibility.done",
        bundle: .module,
        comment: "Accessibility hint for the tap target that marks a done item as to-do again."
    )

    static let itemToggleErrorTitle = String(
        localized: "ql.item.toggle.error.title",
        bundle: .module,
        comment: "Title of the alert displayed when toggling an item's done state failed."
    )

    static let itemToggleErrorMessage = String(
        localized: "ql.item.toggle.error.message",
        bundle: .module,
        comment: "Body of the alert displayed when toggling an item's done state failed."
    )

    static let itemMoveToRayon = String(
        localized: "ql.item.moveToRayon",
        bundle: .module,
        comment: "Title of the context menu entry that opens the move-to-rayon picker."
    )

    static let itemCategoryErrorTitle = String(
        localized: "ql.item.category.error.title",
        bundle: .module,
        comment: "Title of the alert displayed when memorising a rayon correction failed."
    )

    static let itemCategoryErrorMessage = String(
        localized: "ql.item.category.error.message",
        bundle: .module,
        comment: "Body of the alert displayed when memorising a rayon correction failed."
    )

    static func rayonLabel(for rawValue: String) -> String {
        switch rawValue {
        case "Fruits & Légumes":
            return String(localized: "ql.rayon.fruitsLegumes", bundle: .module,
                          comment: "Localised display name of the Fruits & Vegetables rayon.")
        case "Boucherie":
            return String(localized: "ql.rayon.boucherie", bundle: .module,
                          comment: "Localised display name of the Butcher rayon.")
        case "Crèmerie":
            return String(localized: "ql.rayon.cremerie", bundle: .module,
                          comment: "Localised display name of the Dairy rayon.")
        case "Épicerie":
            return String(localized: "ql.rayon.epicerie", bundle: .module,
                          comment: "Localised display name of the Pantry rayon.")
        case "Surgelés":
            return String(localized: "ql.rayon.surgeles", bundle: .module,
                          comment: "Localised display name of the Frozen rayon.")
        case "Boulangerie":
            return String(localized: "ql.rayon.boulangerie", bundle: .module,
                          comment: "Localised display name of the Bakery rayon.")
        case "Boissons":
            return String(localized: "ql.rayon.boissons", bundle: .module,
                          comment: "Localised display name of the Beverages rayon.")
        case "Hygiène":
            return String(localized: "ql.rayon.hygiene", bundle: .module,
                          comment: "Localised display name of the Hygiene rayon.")
        default:
            return rayonAutres
        }
    }
}
