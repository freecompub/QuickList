import Foundation

public enum QuickListStrings {
    public static let addItemPlaceholder = String(
        localized: "ql.addItem.placeholder",
        bundle: .module,
        comment: "Placeholder of the persistent add-item bar at the bottom of a list."
    )

    public static let addItemSubmit = String(
        localized: "ql.addItem.submit",
        bundle: .module,
        comment: "Accessibility label of the add button next to the add-item bar."
    )

    public static let listEmptyTitle = String(
        localized: "ql.list.empty.title",
        bundle: .module,
        comment: "Title shown on a list that has no item yet."
    )

    public static let listEmptySubtitle = String(
        localized: "ql.list.empty.subtitle",
        bundle: .module,
        comment: "Subtitle shown on a list that has no item yet."
    )
}
