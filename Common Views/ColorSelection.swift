import Foundation
import SwiftUI


struct ColorSelection: View {
    let colors: [Color] = [
        Color.red,
        Color.orange,
        Color.yellow,
        Color.green,
        Color.blue,
        Color.purple,
        Color.pink,
        Color.black
    ]
    
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    ColorButton(color: color, action: { selectedColor = color })
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minWidth: 0)
                    if selectedColor == color {
                        Circle()
                            .stroke(color.opacity(0.5), lineWidth: 5)
                            .frame(width: 30, height: 30)
                    }
                }
            }
        }
    }
}

struct ColorButton: View {
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "circle.fill")
        }
        .buttonStyle(RadioButtonStyle(color: color))
    }
}

struct ColorSelection_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    static var previews: some View {
        ColorSelection(selectedColor: .constant(.red))
    }
}
