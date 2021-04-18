import SwiftUI

struct PlusButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus").resizable().frame(width: 20, height: 20)
        }.buttonStyle(PlusButtonStyle())
    }
}

struct PlusButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.padding(.horizontal).foregroundColor(.accentColor)
    }
}
