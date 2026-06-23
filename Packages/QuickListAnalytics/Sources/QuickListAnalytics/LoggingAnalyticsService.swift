import Foundation
import Logging

public final class LoggingAnalyticsService: AnalyticsService {
    private let logger: Logger

    public init(logger: Logger = Logger(label: "quicklist.analytics")) {
        self.logger = logger
    }

    public func track(_ event: AnalyticsEvent) {
        let propertiesDescription = event.properties.isEmpty
            ? "{}"
            : event.properties
                .sorted { $0.key < $1.key }
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: ", ")
        logger.info("analytics_event \(event.name) [\(propertiesDescription)]")
    }
}
