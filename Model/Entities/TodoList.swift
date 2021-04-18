import Foundation
import SwiftUI
import Combine

class TodoList {
    var id: UUID
    var title: String
    var color: Color
    var openTasks: [Task] = []
    var closedTasks: [Task] = []
    
    init(id: UUID? = nil, title: String, color: Color, openTasks: [Task] = [], closedTasks: [Task] = []) {
        self.id = id ?? UUID()
        self.title = title
        self.color = color
        self.openTasks = openTasks
        self.closedTasks = closedTasks
    }
}

extension TodoList: Identifiable {}
