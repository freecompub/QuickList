import Foundation

public enum Symbol {
    public static let qlAddItem = "plus.circle.fill"
    public static let qlCreateList = "plus.square.fill.on.square.fill"
    public static let qlDeleteItem = "trash.fill"
    public static let qlEmptyChecklist = "checklist"
    public static let qlListTypeGroceries = "cart.fill"
    public static let qlListTypeTasks = "checklist"
    public static let qlListTypeIdeas = "lightbulb.fill"
    public static let qlListTypeProjects = "folder.fill"
    public static let qlListTypeFavorites = "star.fill"
    public static let qlRenameList = "pencil"
    public static let qlOptionsList = "ellipsis.circle"
    public static let qlSortMenu = "line.3.horizontal.decrease.circle"
    public static let qlItemCheckedOn = "checkmark.circle.fill"
    public static let qlItemCheckedOff = "circle"

    public static let qlRayonFruitsLegumes = "leaf.fill"
    public static let qlRayonBoucherie = "fork.knife"
    public static let qlRayonCremerie = "drop.fill"
    public static let qlRayonEpicerie = "archivebox.fill"
    public static let qlRayonSurgeles = "snowflake"
    public static let qlRayonBoulangerie = "birthday.cake.fill"
    public static let qlRayonBoissons = "cup.and.saucer.fill"
    public static let qlRayonHygiene = "shower.fill"
    public static let qlRayonAutres = "square.grid.2x2.fill"

    public static func icon(forRayonRawValue rawValue: String) -> String {
        switch rawValue {
        case "Fruits & Légumes": return qlRayonFruitsLegumes
        case "Boucherie": return qlRayonBoucherie
        case "Crèmerie": return qlRayonCremerie
        case "Épicerie": return qlRayonEpicerie
        case "Surgelés": return qlRayonSurgeles
        case "Boulangerie": return qlRayonBoulangerie
        case "Boissons": return qlRayonBoissons
        case "Hygiène": return qlRayonHygiene
        default: return qlRayonAutres
        }
    }
}
