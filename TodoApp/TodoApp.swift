import SwiftUI
import Foundation
import Combine

@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(model: MockModel())
        }
    }
}
