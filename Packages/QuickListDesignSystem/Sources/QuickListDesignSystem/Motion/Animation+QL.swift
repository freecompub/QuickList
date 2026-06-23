import SwiftUI

public enum Motion {
    public static let qlQuick: Animation = .spring(response: 0.2, dampingFraction: 0.8)
    public static let qlStandard: Animation = .spring(response: 0.3, dampingFraction: 0.75)
    public static let qlExpressive: Animation = .spring(response: 0.4, dampingFraction: 0.65)
    public static let qlFade: Animation = .easeInOut(duration: 0.2)
    public static let qlItemInsert: Animation = .spring(response: 0.35, dampingFraction: 0.8)
    public static let qlCheckmark: Animation = .spring(response: 0.25, dampingFraction: 0.6)
}
