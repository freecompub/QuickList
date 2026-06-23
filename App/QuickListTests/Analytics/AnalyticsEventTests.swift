import QuickListAnalytics
import XCTest

final class AnalyticsEventTests: XCTestCase {

    func test_event_initWithDefaultProperties_isEmpty() {
        let event = AnalyticsEvent(name: "item_added")
        XCTAssertEqual(event.name, "item_added")
        XCTAssertTrue(event.properties.isEmpty)
    }

    func test_event_carriesProperties() {
        let event = AnalyticsEvent(name: "item_added", properties: ["source": "keyboard"])
        XCTAssertEqual(event.properties["source"], "keyboard")
    }
}
