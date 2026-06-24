import Foundation

extension QuickListStrings {
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
