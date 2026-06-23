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
}
