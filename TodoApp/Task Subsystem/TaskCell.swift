import Foundation
import SwiftUI

struct TaskCell: View {
    var onClick: () -> Void
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        Button(action: onClick) {
            HStack {
                RadioButton(action: { viewModel.toggleClosed() }, checked: $viewModel.closed)
                VStack(alignment: .leading) {
                    Text(viewModel.title).foregroundColor(.black).font(.system(size: 20))
                    Text(viewModel.description).foregroundColor(.gray).font(.system(size: 15))
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            viewModel.updateStates()
        }
    }
    
    init(action: @escaping () -> Void, id: Task.ID, listViewModel: TodoListViewModel) {
        self.onClick = action
        self.viewModel = TaskViewModel(id: .constant(id), listViewModel: listViewModel)
    }
}

struct TaskCellView_Previews: PreviewProvider {
    @ObservedObject private static var model: Model = MockModel()
    
    static var previews: some View {
        TaskCell(action: {}, id: model.lists[0].openTasks[0].id, listViewModel: TodoListViewModel(model, id: model.lists[0].id))
    }
}
