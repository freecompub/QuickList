import Foundation

@MainActor
public protocol TaskListRepository: AnyObject {
    func fetchAll() throws -> [TaskList]
    func create(name: String, type: ListType) throws -> TaskList
    func rename(_ list: TaskList, to newName: String) throws
    func delete(_ list: TaskList) throws
}
