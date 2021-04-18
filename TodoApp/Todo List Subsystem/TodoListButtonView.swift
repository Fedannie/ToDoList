import Foundation
import SwiftUI

struct TodoListButtonView: View {
    @ObservedObject private var model: Model
    private let id: TodoList.ID
    
    @State var openTasks = 0
    
    var body: some View {
        model.list(id).map { todoList in
            VStack {
                CycleText(todoList: todoList, number: $openTasks)
                Text(todoList.title)
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                    .padding(.bottom)
            }
            .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(todoList.color, lineWidth: 2))
            .padding()
            .fixedSize(horizontal: false, vertical: true)
            .aspectRatio(1, contentMode: .fit)
        }
    }
    
    init(_ model: Model, id: TodoList.ID) {
        self.model = model
        self.id = id
    }
}

struct TodoListButtonView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    static var previews: some View {
        TodoListButtonView(model, id: model.lists[0].id)
    }
}
