//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//

import SwiftUI

public struct TextFieldAndRightIcon: View {
    @Binding var number: String
    @State var iconName = "person"
    @State var placeHolder = "Mobile number"
    @State var keyboardType: UIKeyboardType = .numberPad
    @FocusState var cursor: Bool
    @Binding var success: Bool
    var onImageClick: () -> Void
    public init(number: Binding<String>, iconName: String = "person", placeHolder: String = "Mobile number", keyboardType: UIKeyboardType = .phonePad, success: Binding<Bool> = .constant(true), onImageClick: @escaping () -> Void = {
        //TODO
    }) {
        self._number = number
        self.iconName = iconName
        self.placeHolder = placeHolder
        self.keyboardType = keyboardType
        self.onImageClick = onImageClick
        _success = success
    }
    public var body: some View {
        HStack {
            TextField(placeHolder, text: $number)
                .keyboardType(keyboardType)
                .submitLabel(.next)
                .focused($cursor)
                .foregroundColor(.black)
            Image(systemName: iconName)
                .onTapGesture {
                    onImageClick()
                }
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
        ).foregroundColor(success ? .black : .red)
   
    }
}




public struct TextFieldAndLeftTitle: View {
    @Binding var number: String
    @Binding var iconName: String
    @State var placeHolder = "Mobile number"
    @State var keyboardType: UIKeyboardType = .numberPad
    @FocusState var cursor: Bool
    @Binding var success: Bool
  
    public init(number: Binding<String>, iconName: Binding<String>, placeHolder: String = "Mobile number", keyboardType: UIKeyboardType = .phonePad, success: Binding<Bool> = .constant(true)
    ) {
        self._number = number
        self._iconName = iconName
        self.placeHolder = placeHolder
        self.keyboardType = keyboardType
        _success = success
    }
    public var body: some View {
        HStack {
            Text(iconName)
                .foregroundColor(success ? .black : .red)
            TextField(placeHolder, text: $number)
                .keyboardType(keyboardType)
                .submitLabel(.next)
                .focused($cursor)
                .foregroundColor(success ? .black : .red)
         
                
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
        ).foregroundColor(success ? .black : .red)
   
    }
}
