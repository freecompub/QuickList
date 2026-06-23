import Foundation
import QuickListCore

@MainActor
final class MockTaskListRepository: TaskListRepository {
    enum Behavior {
        case success
        case fail(Error)
    }

    var createBehavior: Behavior = .success

    private(set) var createdNames: [String] = []
    private(set) var createdTypes: [ListType] = []
    private(set) var lastCreatedList: TaskList?
    var storedLists: [TaskList] = []

    func fetchAll() throws -> [TaskList] {
        storedLists
    }

    func create(name: String, type: ListType) throws -> TaskList {
        switch createBehavior {
        case .success:
            createdNames.append(name)
            createdTypes.append(type)
            let list = TaskList(name: name, type: type)
            storedLists.append(list)
            lastCreatedList = list
            return list
        case .fail(let error):
            throw error
        }
    }
}
