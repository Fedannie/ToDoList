import Foundation
import SwiftUI

class MockModel: Model {
    init() {
        var lists: [TodoList] = []
        lists.append(TodoList(title: "First list", color: Color.red))
        lists[0].openTasks.append(Task(title: "First task", description: "The first task"))
        lists[0].openTasks.append(Task(title: "Second task", description: "The second task"))
        lists[0].closedTasks.append(Task(title: "Third task", description: "The third task", closed: true))
        lists[0].closedTasks.append(Task(title: "Fourth task", description: "The fourth task", closed: true))
        lists.append(TodoList(title: "HA App 3", color: Color.blue))
        lists[1].openTasks.append(Task(title: "Second task", description: "The second task"))
        lists[1].closedTasks.append(Task(title: "Third task", description: "The third task", closed: true))
        lists.append(TodoList(title: "HA 7&8", color: Color.green))
        lists[2].openTasks.append(Task(title: "Second task", description: "The second task"))
        lists.append(TodoList(title: "Tutlorials", color: Color.yellow))
        lists[3].closedTasks.append(Task(title: "Third task", description: "The third task", closed: true))
        super.init(lists: lists)
    }
}
