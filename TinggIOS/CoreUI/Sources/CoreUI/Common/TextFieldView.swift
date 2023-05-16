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
    @Binding var onError: Bool
    @State private var color: Color = .black
    @FocusState fileprivate var cursor: Bool
    var keyBoardType: UIKeyboardType = .default
    public init (fieldText: Binding<String>, label: String, placeHolder: String, type: UIKeyboardType = .default, success: Binding<Bool> = .constant(false), onError: Binding<Bool> = .constant(false)) {
        self._fieldText = fieldText
        _label = State(initialValue: label)
        _placeHolder = State(initialValue: placeHolder)
        keyBoardType = type
        _success = success
        _onError = onError
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(label)
                    .foregroundColor(.black)
                    .font(.subheadline)
                TextField(placeHolder, text: $fieldText)
                    .keyboardType(keyBoardType)
                    .padding(15)
                    .focused($cursor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                            .fill(color)
//                            .foregroundColor(color)
                    )
            }
            .onChange(of: fieldText) { newValue in
                color = success ? . green : .red
                if !newValue.isEmpty {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        cursor = false
//                    }
                }
            }
        }
    }
}

public struct SecureTextFieldView: View {
    @Binding var fieldText: String
    @State var label: String
    @State var placeHolder: String
    @Binding var valid: Bool
    @State private var color: Color = .black
    public init (fieldText: Binding<String>, label: String, placeHolder: String, valid: Binding<Bool> = .constant(false)) {
        self._fieldText = fieldText
        _label = State(initialValue: label)
        _valid = valid
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
                    ).foregroundColor(color)
            }
        }
        .onChange(of: fieldText) { newValue in
            color = valid ? .green : .red
        }
    }
}

