//
//  TextFieldView.swift
//  
//
//  Created by Abdulrasaq on 06/09/2022.
//

import Foundation
import SwiftUI


/// A text field view with a title label
public struct TextFieldView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var fieldText: String
    @State var label: String
    @State var placeHolder: String
    @State private var color: Color = .black
    @FocusState fileprivate var cursor: Bool
    var keyBoardType: UIKeyboardType = .default
    private var validation: (String) -> Bool
    public init (fieldText: Binding<String>, label: String, placeHolder: String, type: UIKeyboardType = .default, validation: @escaping (String) -> Bool = {_ in true }) {
        self._fieldText = fieldText
        _label = State(initialValue: label)
        _placeHolder = State(initialValue: placeHolder)
        keyBoardType = type
        self.validation = validation
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(label)
                    .foregroundColor(.black)
                    .font(.subheadline)
                TextField(placeHolder, text: $fieldText, prompt: Text(placeHolder).foregroundColor(.gray))
                    .keyboardType(keyBoardType)
                    .padding(15)
                    .focused($cursor)
                    .foregroundColor(.black)
                    .validateBorderStyle(text: $fieldText, validation: validation)
            }
        }
    }
}

public struct SecureTextFieldView: View {
    @Binding var fieldText: String
    @State var label: String
    @State var placeHolder: String
    @State private var color: Color = .black
    var keyboardType: UIKeyboardType
    private var validation: (String) -> Bool
    public init (fieldText: Binding<String>, label: String, placeHolder: String, keyboardType: UIKeyboardType = .default, validation: @escaping (String) -> Bool) {
        self._fieldText = fieldText
        _label = State(initialValue: label)
        _placeHolder = State(initialValue: placeHolder)
        self.keyboardType = keyboardType
        self.validation = validation
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(label)
                    .foregroundColor(.black)
                SecureField(placeHolder, text: $fieldText)
                    .keyboardType(keyboardType)
                    .padding()
                    .validateBorderStyle(text: $fieldText, validation: validation)
            }
        }
       
    }
}

struct SecureTextFieldView_Previews: PreviewProvider {
    struct SecureTextFieldViewHolder: View {
        @State var password: String = ""
        @State var confirmPassword: String = ""
        @State var placeHolder: String = "Enter password"
        @State var label: String = "Enter"
        @State var pinPermission1 = ""
        @State var pinIsCreated: Bool = false
        var body: some View {
            SecureTextFieldView(fieldText: $password, label: label, placeHolder: placeHolder) { str in
                true
            }
        }
    }
    static var previews: some View {
        SecureTextFieldViewHolder()
    }
}

