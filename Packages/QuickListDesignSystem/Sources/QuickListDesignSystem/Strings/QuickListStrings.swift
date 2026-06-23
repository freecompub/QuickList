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
}
