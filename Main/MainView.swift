import Foundation
import SwiftUI
import Combine

struct MainView: View {
    private let welcome = "Welcome!"
    @ObservedObject var model: Model
    
    let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]
    
    @State var message = ""
    @State var showSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(welcome)
                        .font(.system(.largeTitle))
                        .padding([.leading, .bottom])
                    Message(model: model, message: $message)
                    HStack(alignment: .bottom) {
                        Text("Your ToDo Lists:").font(.system(Font.TextStyle.headline)).bold().padding([.leading, .top])
                        Spacer()
                        PlusButton(action: { showSheet = true })
                    }
                    LazyVGrid(columns: columns) {
                        ForEach(model.lists) { todoList in
                            NavigationLink(destination: TodoView(model, id: todoList.id)) {
                                TodoListButtonView(model, id: todoList.id)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .sheet(isPresented: $showSheet) {
                EditListView(viewModel: TodoListViewModel(model))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
        }
    }
}

struct Message: View {
    @ObservedObject var model: Model
    @Binding var message: String
    
    var body: some View {
        Text(message)
            .font(.system(.headline))
            .multilineTextAlignment(.leading)
            .padding(.leading)
            .onAppear {
                let openTasks = model.lists.reduce(into: 0, { $0 += $1.openTasks.count })
                let openLists = model.lists.filter { !$0.openTasks.isEmpty }.count
                let ending = openLists > 0 ? " in \(openLists) list" + (openLists == 1 ? "" : "s") : ""
                self.message = "You have \(openTasks) open task" + ((openTasks > 1) ? "s" : "") + ending
            }
    }
}

struct MainView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    static var previews: some View {
        MainView(model: model)
    }
}
