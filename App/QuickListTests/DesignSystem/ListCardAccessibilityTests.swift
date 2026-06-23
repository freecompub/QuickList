import QuickListDesignSystem
import XCTest

final class ListCardAccessibilityTests: XCTestCase {

    func test_accessibility_zero_includesTypeAndName() {
        let label = QuickListStrings.listCardAccessibility(
            typeLabel: "Courses",
            name: "Samedi",
            unfinishedCount: 0
        )

        XCTAssertTrue(label.contains("Courses"))
        XCTAssertTrue(label.contains("Samedi"))
        XCTAssertFalse(label.contains("0 à faire"))
    }

    func test_accessibility_nonZero_includesCount() {
        let label = QuickListStrings.listCardAccessibility(
            typeLabel: "Tâches",
            name: "Boulot",
            unfinishedCount: 3
        )

        XCTAssertTrue(label.contains("Tâches"))
        XCTAssertTrue(label.contains("Boulot"))
        XCTAssertTrue(label.contains("3"))
    }
}
