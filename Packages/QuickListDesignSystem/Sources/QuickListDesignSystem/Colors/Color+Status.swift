import SwiftUI

public extension Color {
    /// Vert système conforme HIG. Light : `#34C759`. Dark : `#30D158`.
    static let qlSuccess = Color(
        light: Color(red: 0x34 / 255, green: 0xC7 / 255, blue: 0x59 / 255),
        dark: Color(red: 0x30 / 255, green: 0xD1 / 255, blue: 0x58 / 255)
    )

    /// Orange système. Light : `#FF9F0A`. Dark : `#FFD60A`.
    static let qlWarning = Color(
        light: Color(red: 0xFF / 255, green: 0x9F / 255, blue: 0x0A / 255),
        dark: Color(red: 0xFF / 255, green: 0xD6 / 255, blue: 0x0A / 255)
    )

    /// Rouge système. Light : `#FF3B30`. Dark : `#FF453A`.
    static let qlDanger = Color(
        light: Color(red: 0xFF / 255, green: 0x3B / 255, blue: 0x30 / 255),
        dark: Color(red: 0xFF / 255, green: 0x45 / 255, blue: 0x3A / 255)
    )
}

private extension Color {
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        self = light
        #endif
    }
}

#if canImport(UIKit)
import UIKit
#endif
