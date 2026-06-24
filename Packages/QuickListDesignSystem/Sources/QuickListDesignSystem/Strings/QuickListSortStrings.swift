import Foundation

public extension QuickListStrings {
    static let sortMenuTitle = String(
        localized: "ql.sort.menu.title",
        bundle: .module,
        comment: "Title of the sort menu accessible from the list detail view."
    )

    static let sortDateAdded = String(
        localized: "ql.sort.dateAdded",
        bundle: .module,
        comment: "Sort option : items sorted by their creation date."
    )

    static let sortAlphabetical = String(
        localized: "ql.sort.alphabetical",
        bundle: .module,
        comment: "Sort option : items sorted alphabetically by title."
    )

    static let sortStatus = String(
        localized: "ql.sort.status",
        bundle: .module,
        comment: "Sort option : items sorted with unfinished first, then finished."
    )

    static let sortErrorTitle = String(
        localized: "ql.sort.error.title",
        bundle: .module,
        comment: "Title of the alert displayed when changing the sort order failed."
    )

    static let sortErrorMessage = String(
        localized: "ql.sort.error.message",
        bundle: .module,
        comment: "Body of the alert displayed when changing the sort order failed."
    )
}
