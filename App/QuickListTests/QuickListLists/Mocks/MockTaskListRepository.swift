import Foundation
import QuickListCore

@MainActor
final class MockTaskListRepository: TaskListRepository {
    enum Behavior {
        case success
        case fail(Error)
    }

    var createBehavior: Behavior = .success
    var renameBehavior: Behavior = .success
    var deleteBehavior: Behavior = .success

    private(set) var createdNames: [String] = []
    private(set) var createdTypes: [ListType] = []
    private(set) var lastCreatedList: TaskList?
    private(set) var renamedLists: [(TaskList, String)] = []
    private(set) var deletedLists: [TaskList] = []
    var storedLists: [TaskList] = []

    var behavior: Behavior {
        get { createBehavior }
        set { createBehavior = newValue }
    }

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

    func rename(_ list: TaskList, to newName: String) throws {
        switch renameBehavior {
        case .success:
            let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else {
                throw TaskListRepositoryError.emptyName
            }
            list.name = trimmed
            renamedLists.append((list, trimmed))
        case .fail(let error):
            throw error
        }
    }

    func delete(_ list: TaskList) throws {
        switch deleteBehavior {
        case .success:
            storedLists.removeAll { $0 === list }
            deletedLists.append(list)
        case .fail(let error):
            throw error
        }
    }
}
