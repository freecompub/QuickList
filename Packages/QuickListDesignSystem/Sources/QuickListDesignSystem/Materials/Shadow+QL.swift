import CoreGraphics
import SwiftUI

public struct ShadowToken {
    public let color: Color
    public let radius: CGFloat
    public let xOffset: CGFloat
    public let yOffset: CGFloat

    public init(color: Color, radius: CGFloat, xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        self.color = color
        self.radius = radius
        self.xOffset = xOffset
        self.yOffset = yOffset
    }
}

public enum Shadow {
    public static let qlAddBar = ShadowToken(
        color: .black.opacity(0.10),
        radius: 12,
        yOffset: -4
    )
    public static let qlToast = ShadowToken(
        color: .black.opacity(0.15),
        radius: 16,
        yOffset: 4
    )
    public static let qlCard = ShadowToken(
        color: .black.opacity(0.08),
        radius: 8,
        yOffset: 2
    )
}

public extension View {
    func qlShadow(_ token: ShadowToken) -> some View {
        shadow(color: token.color, radius: token.radius, x: token.xOffset, y: token.yOffset)
    }
}
