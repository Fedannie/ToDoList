import Foundation
import Combine

struct Task {
    var id: UUID
    var title: String
    var description: String
    var closed: Bool
    
    init(id: UUID? = nil, title: String, description: String, closed: Bool = false) {
        self.id = id ?? UUID()
        self.title = title
        self.description = description
        self.closed = closed
    }
}

extension Task: Identifiable { }
