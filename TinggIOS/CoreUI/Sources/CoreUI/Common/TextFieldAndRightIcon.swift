//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//

import SwiftUI

public struct TextFieldAndRightIcon: View {
    @Binding var number: String
    @FocusState var cursor: Bool
    var iconName = "person"
    var placeHolder = "Mobile number"
    var keyboardType: UIKeyboardType = .numberPad
    private var validation: (String) -> Bool
    private var onImageClick: () -> Void
    public init(number: Binding<String>, iconName: String = "person", placeHolder: String = "Mobile number", keyboardType: UIKeyboardType = .phonePad, validation: @escaping (String) -> Bool = {_ in false }, onImageClick: @escaping () -> Void = {
        //TODO
    }) {
        self._number = number
        self.iconName = iconName
        self.placeHolder = placeHolder
        self.keyboardType = keyboardType
        self.onImageClick = onImageClick
        self.validation = validation
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
        }.padding(15)
        .validateBorderStyle(text: $number, validation: validation)
    }
}




public struct TextFieldAndLeftTitle: View {
    @Binding var number: String
    var iconName: String
    @State var placeHolder = "Mobile number"
    @State var keyboardType: UIKeyboardType = .numberPad
    @FocusState var cursor: Bool
    private var validation: (String) -> Bool
    
    public init(number: Binding<String>, iconName: String, placeHolder: String = "Mobile number", keyboardType: UIKeyboardType = .phonePad, validation: @escaping (String) -> Bool = {_ in false }
    ) {
        self._number = number
        self.iconName = iconName
        self.placeHolder = placeHolder
        self.keyboardType = keyboardType
        self.validation = validation

    }
    public var body: some View {
        HStack {
            Text(iconName)
            TextField(placeHolder, text: $number)
                .keyboardType(keyboardType)
                .submitLabel(.next)
                .focused($cursor)
                
        }.padding(15)
        .validateBorderStyle(text: $number, validation: validation)
   
    }
}
