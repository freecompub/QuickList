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

    public static let listItemDelete = String(
        localized: "ql.list.item.delete",
        bundle: .module,
        comment: "Title of the swipe action that deletes an item from a list."
    )

    public static let undoToastUndo = String(
        localized: "ql.undoToast.undo",
        bundle: .module,
        comment: "Visible label of the undo button inside the undo toast."
    )

    public static let undoToastUndoAccessibility = String(
        localized: "ql.undoToast.undo.accessibility",
        bundle: .module,
        comment: "Accessibility label of the undo button inside the undo toast."
    )

    public static func undoToastDeleted(title: String) -> String {
        let format = String(
            localized: "ql.undoToast.deleted",
            bundle: .module,
            comment: "Message of the undo toast after deleting an item — %@ is the item title."
        )
        return String(format: format, title)
    }

    public static let errorTitle = String(
        localized: "ql.error.title",
        bundle: .module,
        comment: "Title of the generic error alert displayed when a user action could not be completed."
    )

    public static let errorDeleteMessage = String(
        localized: "ql.error.delete",
        bundle: .module,
        comment: "Body of the error alert shown when an item deletion failed."
    )

    public static let errorRestoreMessage = String(
        localized: "ql.error.restore",
        bundle: .module,
        comment: "Body of the error alert shown when an item restore (undo) failed."
    )

    public static let errorDismiss = String(
        localized: "ql.error.dismiss",
        bundle: .module,
        comment: "Acknowledge button of the generic error alert."
    )
}
