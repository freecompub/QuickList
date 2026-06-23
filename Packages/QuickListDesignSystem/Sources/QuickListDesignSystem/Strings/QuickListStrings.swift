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

    public static let createListTitle = String(
        localized: "ql.create.list.title",
        bundle: .module,
        comment: "Title of the sheet used to create a new list."
    )

    public static let createListNamePlaceholder = String(
        localized: "ql.create.list.namePlaceholder",
        bundle: .module,
        comment: "Placeholder of the name field inside the create-list sheet."
    )

    public static let createListCreate = String(
        localized: "ql.create.list.create",
        bundle: .module,
        comment: "Primary action button of the create-list sheet."
    )

    public static let createListCancel = String(
        localized: "ql.create.list.cancel",
        bundle: .module,
        comment: "Cancel button of the create-list sheet."
    )

    public static let createListTypeHeader = String(
        localized: "ql.create.list.typeHeader",
        bundle: .module,
        comment: "Section header above the list-type selector."
    )

    public static let createListErrorTitle = String(
        localized: "ql.create.list.error.title",
        bundle: .module,
        comment: "Title of the alert displayed when list creation failed."
    )

    public static let createListErrorMessage = String(
        localized: "ql.create.list.error.message",
        bundle: .module,
        comment: "Body of the alert displayed when list creation failed."
    )

    public static let createListErrorDismiss = String(
        localized: "ql.create.list.error.dismiss",
        bundle: .module,
        comment: "Acknowledge button of the create-list error alert."
    )

    public static let listTypeGroceries = String(
        localized: "ql.list.type.groceries",
        bundle: .module,
        comment: "Label of the groceries list type."
    )

    public static let listTypeTasks = String(
        localized: "ql.list.type.tasks",
        bundle: .module,
        comment: "Label of the tasks list type."
    )

    public static let listTypeIdeas = String(
        localized: "ql.list.type.ideas",
        bundle: .module,
        comment: "Label of the ideas list type."
    )

    public static let listTypeProjects = String(
        localized: "ql.list.type.projects",
        bundle: .module,
        comment: "Label of the projects list type."
    )

    public static let listTypeFavorites = String(
        localized: "ql.list.type.favorites",
        bundle: .module,
        comment: "Label of the favorites list type."
    )

    public static let rootNewList = String(
        localized: "ql.root.newList",
        bundle: .module,
        comment: "Title of the toolbar button that opens the create-list sheet."
    )

    public static let rootNewListAccessibility = String(
        localized: "ql.root.newList.accessibility",
        bundle: .module,
        comment: "Accessibility label of the toolbar button that opens the create-list sheet."
    )

    public static let homeTitle = String(
        localized: "ql.home.title",
        bundle: .module,
        comment: "Navigation title of the home view that lists all task lists."
    )

    public static let homeEmptyTitle = String(
        localized: "ql.home.empty.title",
        bundle: .module,
        comment: "Title shown when the user has no list yet."
    )

    public static let homeEmptySubtitle = String(
        localized: "ql.home.empty.subtitle",
        bundle: .module,
        comment: "Subtitle shown when the user has no list yet — invites to create one."
    )

    public static let listOptionsRename = String(
        localized: "ql.list.options.rename",
        bundle: .module,
        comment: "Context menu / sheet entry that opens the inline rename UI for a list."
    )

    public static let listOptionsDelete = String(
        localized: "ql.list.options.delete",
        bundle: .module,
        comment: "Context menu / sheet entry that triggers the delete confirmation for a list."
    )

    public static let listOptionsCancel = String(
        localized: "ql.list.options.cancel",
        bundle: .module,
        comment: "Cancel button shared by list option flows (rename, delete confirmation)."
    )

    public static let listOptionsConfirm = String(
        localized: "ql.list.options.confirm",
        bundle: .module,
        comment: "Confirmation button of the inline rename flow."
    )

    public static let listRenameTitle = String(
        localized: "ql.list.rename.title",
        bundle: .module,
        comment: "Title of the rename-list sheet."
    )

    public static let listRenamePlaceholder = String(
        localized: "ql.list.rename.placeholder",
        bundle: .module,
        comment: "Placeholder of the rename-list text field."
    )

    public static func listDeleteConfirmTitle(listName: String) -> String {
        let format = String(
            localized: "ql.list.delete.confirm.title",
            bundle: .module,
            comment: "Title of the delete-list confirmation alert — %@ is the list name."
        )
        return String(format: format, listName)
    }

    public static let listDeleteConfirmMessage = String(
        localized: "ql.list.delete.confirm.message",
        bundle: .module,
        comment: "Body of the delete-list confirmation alert."
    )

    public static let listRenameErrorTitle = String(
        localized: "ql.list.rename.error.title",
        bundle: .module,
        comment: "Title of the alert displayed when renaming a list failed."
    )

    public static let listRenameErrorMessage = String(
        localized: "ql.list.rename.error.message",
        bundle: .module,
        comment: "Body of the alert displayed when renaming a list failed."
    )

    public static let listDeleteErrorTitle = String(
        localized: "ql.list.delete.error.title",
        bundle: .module,
        comment: "Title of the alert displayed when deleting a list failed."
    )

    public static let listDeleteErrorMessage = String(
        localized: "ql.list.delete.error.message",
        bundle: .module,
        comment: "Body of the alert displayed when deleting a list failed."
    )

    public static let sortMenuTitle = String(
        localized: "ql.sort.menu.title",
        bundle: .module,
        comment: "Title of the sort menu accessible from the list detail view."
    )

    public static let sortDateAdded = String(
        localized: "ql.sort.dateAdded",
        bundle: .module,
        comment: "Sort option : items sorted by their creation date."
    )

    public static let sortAlphabetical = String(
        localized: "ql.sort.alphabetical",
        bundle: .module,
        comment: "Sort option : items sorted alphabetically by title."
    )

    public static let sortStatus = String(
        localized: "ql.sort.status",
        bundle: .module,
        comment: "Sort option : items sorted with unfinished first, then finished."
    )

    public static let sortErrorTitle = String(
        localized: "ql.sort.error.title",
        bundle: .module,
        comment: "Title of the alert displayed when changing the sort order failed."
    )

    public static let sortErrorMessage = String(
        localized: "ql.sort.error.message",
        bundle: .module,
        comment: "Body of the alert displayed when changing the sort order failed."
    )

    public static func listCardAccessibility(
        typeLabel: String,
        name: String,
        unfinishedCount: Int
    ) -> String {
        if unfinishedCount == 0 {
            let format = String(
                localized: "ql.list.card.accessibility.zero",
                bundle: .module,
                comment: "Accessibility label of ListCard with no unfinished item. %1$@ = type, %2$@ = name."
            )
            return String(format: format, typeLabel, name)
        }
        let format = String(
            localized: "ql.list.card.accessibility.unfinished",
            bundle: .module,
            comment: "Accessibility label of ListCard with unfinished items. %1$@ type, %2$@ name, %3$d count."
        )
        return String(format: format, typeLabel, name, unfinishedCount)
    }

    public static func itemCount(_ count: Int) -> String {
        if count == 0 {
            return String(
                localized: "ql.list.itemCount.zero",
                bundle: .module,
                comment: "Subtitle of a list card when it contains no item."
            )
        }
        if count == 1 {
            let format = String(
                localized: "ql.list.itemCount.singular",
                bundle: .module,
                comment: "Singular item count of a list card — %d is the count."
            )
            return String(format: format, count)
        }
        let format = String(
            localized: "ql.list.itemCount.plural",
            bundle: .module,
            comment: "Plural item count of a list card — %d is the count."
        )
        return String(format: format, count)
    }
}
