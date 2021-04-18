import Foundation
import SwiftUI

struct TodoView: View {
    private let openTitle = "Open tasks"
    private let closedTitle = "Closed tasks"
    
    @ObservedObject private var viewModel: TodoListViewModel
    @ObservedObject var sheet = SettingsSheet()
    @State var taskId: Task.ID?
    var id: TodoList.ID
    
    var body: some View {
        List {
            Section(header: HStack {
                Text(openTitle)
                Spacer()
                PlusButton(action: { setState() })
            }) {
                ForEach(viewModel.openTasks) { task in cell(task.id) }
            }
            
            Section(header: Text(closedTitle)) {
                ForEach(viewModel.closedTasks) { task in cell(task.id) }
            }
        }
        .sheet(isPresented: $sheet.isShowing, content: sheetContent)
        .listStyle(GroupedListStyle())
        .onAppear { viewModel.updateStates() }
        .navigationBarTitle(viewModel.model?.list(id)?.title ?? "", displayMode: .inline)
        .toolbar {
            ToolbarItem {
                Button(action: { setState(showList: true) }) {
                    Image(systemName: "pencil")
                }
            }
        }
    }
    
    init(_ model: Model, id: TodoList.ID) {
        self.viewModel = TodoListViewModel(model, id: id)
        self.id = id
    }
    
    @ViewBuilder
    private func sheetContent() -> some View {
        if sheet.state == .todoList {
            EditListView(viewModel: viewModel)
        } else {
            EditTaskView(viewModel: TaskViewModel(id: $taskId, listViewModel: viewModel), id: $taskId)
        }
    }
    
    func cell(_ id: Task.ID) -> some View {
        TaskCell(
            action: { setState(taskId: id) },
            id: id,
            listViewModel: viewModel)
    }
    
    func setState(taskId: Task.ID? = nil, showList: Bool = false) {
        self.taskId = taskId
        if showList {
            sheet.state = .todoList
        } else {
            sheet.state = .task
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    private static var model: Model = MockModel()
    
    static var previews: some View {
        TodoView(model, id: model.lists[0].id)
    }
}
