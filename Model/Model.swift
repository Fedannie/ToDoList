import Foundation
import Combine

class Model: ObservableObject {
    @Published var lists: [TodoList]
    var open: Int {
        lists.reduce(into: 0) { $0 += $1.openTasks.count }
    }
    var openLists: Int {
        lists.filter { !$0.openTasks.isEmpty }.count
    }
    
    init(lists: [TodoList] = []) {
        self.lists = lists
    }
    
    func list(_ id: TodoList.ID) -> TodoList? {
        lists.first { $0.id == id }
    }
    
    private func task(_ id: Task.ID, keyPath: KeyPath<TodoList, [Task]>) -> Task? {
        let filterResult = lists.compactMap { $0[keyPath: keyPath].first { $0.id == id } }
        return filterResult.isEmpty ? nil : filterResult[0]
    }
    
    func task(_ id: Task.ID) -> Task? {
        guard let result = task(id, keyPath: \.openTasks) else {
            return task(id, keyPath: \.closedTasks)
        }
        return result
    }
    
    func save(list: TodoList) {
        guard let index = lists.firstIndex(where: { $0.id == list.id }) else {
            lists.append(list)
            return
        }
        lists[index] = list
    }

    func save(listId: TodoList.ID, task: Task) {
        guard let list = list(listId) else {
            return
        }
        if task.closed {
            guard let index = list.closedTasks.firstIndex(where: { $0.id == task.id }) else {
                list.closedTasks.append(task)
                return
            }
            list.closedTasks.removeAll { $0.id == task.id }
            list.closedTasks.insert(task, at: index)
        } else {
            guard let index = list.openTasks.firstIndex(where: { $0.id == task.id }) else {
                list.openTasks.append(task)
                return
            }
            list.openTasks.removeAll { $0.id == task.id }
            list.openTasks.insert(task, at: index)
        }
    }
    
    func delete(listId: TodoList.ID, taskId: Task.ID) {
        guard let list = list(listId) else {
            return
        }
        list.openTasks.removeAll { $0.id == taskId }
        list.closedTasks.removeAll { $0.id == taskId }
    }
}
