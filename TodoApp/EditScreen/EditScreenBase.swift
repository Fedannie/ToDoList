import Foundation
import SwiftUI

protocol EditScreenBase {
    var presentationMode: Binding<PresentationMode> { get }
    
    associatedtype SectionView: View
    var customSections: SectionView { get }
    
    associatedtype ContentView: View
    func content(
        textFieldTitle: String,
        instructions: String,
        buttonTitle: String,
        delete: (() -> Void)?,
        title: Binding<String>) -> ContentView
    func save()
    func disableSaveButton() -> Bool
}

extension EditScreenBase {
    func content(
        textFieldTitle: String,
        instructions: String,
        buttonTitle: String,
        delete: (() -> Void)? = nil,
        title: Binding<String>
    ) -> some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text(textFieldTitle)) {
                    TextField("Title", text: title).textFieldStyle(CustomTextFieldStyle())
                    Text(instructions).foregroundColor(Color.gray).multilineTextAlignment(.leading)
                }
                customSections
            }
            .listStyle(PlainListStyle())
            
            HStack(spacing: 10) {
                addDeleteButton(action: delete)
                addSaveButton(action: {
                    save()
                    presentationMode.wrappedValue.dismiss()
                }, title: buttonTitle)
            }.padding(10)
        }
        .buttonStyle(SaveButtonStyle())
        .toolbar(content: {
            ToolbarItem {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                }
            }
        })
    }
    
    private func addSaveButton(action: @escaping () -> Void, title: String) -> some View {
        Button(action: action) {
            Text(title).padding()
        }.disabled(disableSaveButton())
    }
    
    private func addDeleteButton(action: (() -> Void)?) -> AnyView {
        guard let delete = action else {
            return AnyView(EmptyView())
        }
        return AnyView(HStack {
            Button(action: {
                delete()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete").padding()
            }
        })
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 1))
            .shadow(color: .gray, radius: 10)
    }
}

struct SaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 4).fill(Color.accentColor))
            .shadow(radius: 5)
    }
}
