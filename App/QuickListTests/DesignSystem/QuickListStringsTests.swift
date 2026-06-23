import QuickListDesignSystem
import XCTest

final class QuickListStringsTests: XCTestCase {

    func test_addItemPlaceholder_isLocalized() {
        XCTAssertFalse(QuickListStrings.addItemPlaceholder.isEmpty)
        XCTAssertNotEqual(QuickListStrings.addItemPlaceholder, "ql.addItem.placeholder")
    }

    func test_addItemSubmit_isLocalized() {
        XCTAssertFalse(QuickListStrings.addItemSubmit.isEmpty)
        XCTAssertNotEqual(QuickListStrings.addItemSubmit, "ql.addItem.submit")
    }
}
