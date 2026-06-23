import Foundation

@MainActor
public protocol TaskListRepository: AnyObject {
    func fetchAll() throws -> [TaskList]
    func create(name: String, type: ListType) throws -> TaskList
}
