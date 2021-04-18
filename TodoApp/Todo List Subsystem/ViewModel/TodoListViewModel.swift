import Foundation
import Combine
import SwiftUI

class TodoListViewModel: ObservableObject {
    enum Constants {
        static let minimalTitleLength = 4
    }
    
    @Published var title: String = ""
    @Published var openTasks: [Task] = []
    @Published var closedTasks: [Task] = []
    @Published var color = Color.red
    @Published var enableSaveButton: Bool = false
    
    weak var model: Model?
    var id: TodoList.ID?
    private var cancellables: Set<AnyCancellable> = []
    
    var validTitle: AnyPublisher<String?, Never> {
        $title
            .map { title in
                guard title.count >= Constants.minimalTitleLength,
                      !(self.model?.lists.contains(where: { $0.title == title && $0.id != self.id }) ?? true) else {
                    return nil
                }
                return title
            }
            .eraseToAnyPublisher()
    }
    
    init(_ model: Model, id: TodoList.ID? = nil) {
        self.model = model
        self.id = id
        
        validTitle
            .map { $0 != nil }
            .assign(to: \.enableSaveButton, on: self)
            .store(in: &cancellables)
        
        updateStates()
    }
    
    func updateStates() {
        guard let id = self.id,
              let list = model?.list(id) else {
            return
        }

        title = list.title
        openTasks = list.openTasks
        closedTasks = list.closedTasks
        color = list.color
    }
    
    func saveTask(task: Task) {
        guard let id = self.id else {
            return
        }
        
        model?.save(listId: id, task: task)
        updateStates()
    }
    
    func deleteTask(_ id: Task.ID) {
        guard let listId = self.id else {
            return
        }
        
        model?.delete(listId: listId, taskId: id)
        updateStates()
    }

    func save() {
        model?.save(list: TodoList(id: id, title: title, color: color, openTasks: openTasks, closedTasks: closedTasks))
    }

    func delete() {
        if let id = self.id {
            model?.lists.removeAll { $0.id == id }
        }
    }
}
