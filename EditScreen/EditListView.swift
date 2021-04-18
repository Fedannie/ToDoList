import Foundation
import SwiftUI

struct EditListView: View, EditScreenBase {
    @Environment(\.presentationMode) internal var presentationMode
    @ObservedObject var viewModel: TodoListViewModel
    private var id: Task.ID? { viewModel.id }
    
    var body: some View {
        NavigationView {
            content(
                textFieldTitle: "List title",
                instructions: """
                    Your list title should
                    • Have at least 4 characters
                    • Not be equal to the title of another list
                    """,
                buttonTitle: id == nil ? "Create list" : "Save list",
                delete: id == nil ? nil : viewModel.delete,
                title: $viewModel.title
            ).navigationBarTitle(id == nil ? "Add todo list" : "Edit todo list", displayMode: .inline)
        }
        .onAppear { viewModel.updateStates() }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var customSections: some View {
        Section(header: Text("List color")) {
            ColorSelection(selectedColor: $viewModel.color)
        }
    }
    
    func save() {
        viewModel.save()
    }

    func disableSaveButton() -> Bool {
        !viewModel.enableSaveButton
    }
}

struct CreateListView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    static var previews: some View {
        EditListView(viewModel: TodoListViewModel(model, id: model.lists[0].id))
    }
}
