import Foundation
import SwiftUI

struct RadioButton: View {
    var action: () -> Void
    @Binding var checked: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: checked ? "largecircle.fill.circle" : "circle").resizable()
        }.buttonStyle(RadioButtonStyle())
    }
}

struct RadioButtonStyle: ButtonStyle {
    var color = Color.accentColor
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 20, height: 20)
            .clipShape(Circle())
            .foregroundColor(color)
            .padding()
    }
}
