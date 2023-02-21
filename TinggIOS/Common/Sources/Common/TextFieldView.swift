//
//  File.swift
//  
//
//  Created by Abdulrasaq on 06/09/2022.
//

import Foundation
import SwiftUI

/// A text field view with a title label
public struct TextFieldView: View {
    @Binding var fieldText: String
    @State var label: String
    @State var placeHolder: String
    @Binding var success: Bool
    @State var onError: Bool = false
    var keyBoardType: UIKeyboardType = .default
    public init (fieldText: Binding<String>, label: String, placeHolder: String, type: UIKeyboardType = .default, success: Binding<Bool> = .constant(true)) {
        self._fieldText = fieldText
        _label = State(initialValue: label)
        _placeHolder = State(initialValue: placeHolder)
        keyBoardType = type
        _success = success
        _onError = State(initialValue: !success.wrappedValue)
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(label)
                    .foregroundColor(.black)
                TextField(placeHolder, text: $fieldText)
                    .keyboardType(keyBoardType)
                    .padding(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                    ).foregroundColor(success ? .green : onError ? .red : .black)
            }
        }
    }
}

public struct SecureTextFieldView: View {
    @Binding var fieldText: String
    @State var label: String
    @State var placeHolder: String
    public init (fieldText: Binding<String>, label: String, placeHolder: String) {
        self._fieldText = fieldText
        _label = State(initialValue: label)
        _placeHolder = State(initialValue: placeHolder)
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(label)
                    .foregroundColor(.black)
                SecureField(placeHolder, text: $fieldText)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                    ).foregroundColor(.black)
            }
        }
    }
}

