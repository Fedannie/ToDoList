import Foundation
import Combine
import SwiftUI

class TaskViewModel: ObservableObject {
    enum Constants {
        static let minimalTitleLength = 2
    }
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var closed: Bool = false
    @Published var enableSaveButton: Bool = true
    
    weak var listViewModel: TodoListViewModel?
    @Binding var id: Task.ID?
    private var cancellables: Set<AnyCancellable> = []

    var validTitle: AnyPublisher<String?, Never> {
        $title
            .map { title in
                guard title.count >= Constants.minimalTitleLength else {
                    return nil
                }
                guard let listId = self.listViewModel?.id else {
                    return nil
                }
                if let viewModel = self.listViewModel {
                    guard let contain = viewModel.model?
                            .list(listId)?.openTasks
                            .contains(where: { $0.title == title && $0.id != self.id }) else {
                        return nil
                    }
                    return !contain ? title : nil
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    init(id: Binding<Task.ID?> = .constant(nil), listViewModel: TodoListViewModel) {
        self._id = id
        self.listViewModel = listViewModel
        
        validTitle
            .map { $0 != nil }
            .assign(to: \.enableSaveButton, on: self)
            .store(in: &cancellables)
        
        updateStates()
    }
    
    func updateStates() {
        guard let id = self.id,
              let task = listViewModel?.model?.task(id) else {
            return
        }
        
        title = task.title
        closed = task.closed
        description = task.description
    }
    
    func toggleClosed() {
        guard let viewModel = listViewModel,
              let id = self.id,
              var element = viewModel.model?.task(id),
              let listId = viewModel.id,
              let list = viewModel.model?.list(listId) else {
            return
        }
        
        element.closed.toggle()
        if self.closed {
            list.closedTasks.removeAll { $0.id == id }
            list.openTasks.append(element)
        } else {
            list.openTasks.removeAll { $0.id == id }
            list.closedTasks.append(element)
        }
        viewModel.updateStates()
    }
    
    func save() {
        listViewModel?.saveTask(task: Task(id: id, title: title, description: description, closed: closed))
    }
    
    func delete() {
        if let id = self.id {
            listViewModel?.deleteTask(id)
        }
    }
}
