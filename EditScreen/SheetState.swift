import Combine

class SheetState<State>: ObservableObject {
    @Published var isShowing = false
    @Published var state: State? {
        didSet { isShowing = state != nil }
    }
}

class SettingsSheet: SheetState<SettingsSheet.State> {
    enum State {
        case todoList
        case task
    }
}
