import Foundation
import SwiftUI

struct EditTaskView: View, EditScreenBase {
    @Environment(\.presentationMode) internal var presentationMode
    @ObservedObject var viewModel: TaskViewModel
    @Binding var id: Task.ID?
    
    var body: some View {
        NavigationView {
            content(
                textFieldTitle: "Task title",
                instructions: """
                    Your task title should
                    • Have at least 2 characters
                    • Not be equal to the title of another open task
                    """,
                buttonTitle: id == nil ? "Create task" : "Save task",
                delete: id == nil ? nil : viewModel.delete,
                title: $viewModel.title
            ).navigationBarTitle(id == nil ? "Add task" : "Edit task", displayMode: .inline)
        }
        .onAppear { viewModel.updateStates() }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var customSections: some View {
        Section(header: Text("Task description")) {
            TextField("Description", text: $viewModel.description).textFieldStyle(CustomTextFieldStyle())
        }
    }
    
    func save() {
        viewModel.save()
    }

    func disableSaveButton() -> Bool {
        !viewModel.enableSaveButton
    }
}

struct EditTaskView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    static var previews: some View {
        EditTaskView(viewModel: TaskViewModel(listViewModel: TodoListViewModel(model, id: model.lists[0].id)), id: .constant(model.lists[0].id))
    }
}
