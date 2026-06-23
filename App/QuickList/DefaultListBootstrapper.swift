import Foundation
import Logging
import QuickListCore

@MainActor
final class DefaultListBootstrapper {
    private let repository: TaskListRepository
    private let logger: Logger

    init(
        repository: TaskListRepository,
        logger: Logger = Logger(label: "quicklist.bootstrap")
    ) {
        self.repository = repository
        self.logger = logger
    }

    func ensureDefault(name: String, type: ListType) {
        do {
            let existing = try repository.fetchAll()
            guard existing.isEmpty else { return }
            _ = try repository.create(name: name, type: type)
        } catch {
            logger.error("bootstrap_default_list_failed reason=\(String(describing: error))")
        }
    }
}
