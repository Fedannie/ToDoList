import Foundation
import SwiftUI

struct CycleText: View {
    private let open = "open"
    var todoList: TodoList
    @Binding var number: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(todoList.color)
                .frame(minWidth: 60, minHeight: 60)
            Text("\(number)\n" + open)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white)
                .lineLimit(2)
        }
        .onAppear { number = todoList.openTasks.count }
        .padding([.top, .leading, .trailing])
    }
}
