import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension Color {
    static let qlAccent = Color.accentColor
    #if canImport(UIKit)
    static let qlBackground = Color(uiColor: .systemBackground)
    static let qlSecondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let qlGroupedBackground = Color(uiColor: .systemGroupedBackground)
    static let qlSurface = Color(uiColor: .secondarySystemGroupedBackground)
    static let qlSeparator = Color(uiColor: .separator)
    static let qlPrimaryLabel = Color(uiColor: .label)
    static let qlSecondaryLabel = Color(uiColor: .secondaryLabel)
    static let qlTertiaryLabel = Color(uiColor: .tertiaryLabel)
    static let qlPlaceholder = Color(uiColor: .placeholderText)
    static let qlItemDone = Color(uiColor: .tertiaryLabel)
    #elseif canImport(AppKit)
    static let qlBackground = Color(nsColor: .windowBackgroundColor)
    static let qlSecondaryBackground = Color(nsColor: .underPageBackgroundColor)
    static let qlGroupedBackground = Color(nsColor: .windowBackgroundColor)
    static let qlSurface = Color(nsColor: .controlBackgroundColor)
    static let qlSeparator = Color(nsColor: .separatorColor)
    static let qlPrimaryLabel = Color(nsColor: .labelColor)
    static let qlSecondaryLabel = Color(nsColor: .secondaryLabelColor)
    static let qlTertiaryLabel = Color(nsColor: .tertiaryLabelColor)
    static let qlPlaceholder = Color(nsColor: .placeholderTextColor)
    static let qlItemDone = Color(nsColor: .tertiaryLabelColor)
    #endif
}
