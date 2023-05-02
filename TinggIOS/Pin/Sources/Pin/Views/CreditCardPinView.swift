//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 10/01/2023.
//

import CoreUI
import CoreNavigation
import Core
import SwiftUI


public struct CreditCardPinView: View {
    @EnvironmentObject var navigation: NavigationUtils
    @Environment(\.dismiss) var dismiss
    private let instruction = "Enter and confirm your pin below"
    private let pinPermission1 = Properties.pinPermission1
    private let pinPermission2 = Properties.pinPermission2
    @Binding var pinPermission: String
    @Binding var pin: String
    @Binding var confirmPin: String
    @Binding var pinIsCreated: Bool
    @State private var buttonBgColor: Color = .gray.opacity(0.5)
    @State private var isValid = false
    @State private var isConfirmPinValid = false
    @State var onSubmit: (Bool) -> Void = {_ in }
    
    public init(pinPermission: Binding<String>, pin: Binding<String>, confirmPin: Binding<String>, pinIsCreated: Binding<Bool>, onSubmit: @escaping (Bool) -> Void = {_ in }) {
        self._pinPermission = pinPermission
        self._pin = pin
        self._confirmPin = confirmPin
        self._pinIsCreated = pinIsCreated
        self.onSubmit = onSubmit
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Text(instruction)
            SecureTextFieldView(fieldText: $pin, label: "", placeHolder: "Enter pin", valid: $isValid)
            SecureTextFieldView(fieldText: $confirmPin, label: "", placeHolder: "Confirm pin", valid: $isConfirmPinValid)
            HRadioButtonAndText(selected: $pinPermission, name: pinPermission1)
                .font(.caption)
                .padding(.vertical)
            HRadioButtonAndText(selected: $pinPermission, name: pinPermission2)
                .font(.caption)
            Spacer()
            TinggButton(backgroundColor: buttonBgColor, buttonLabel: "Continue", padding: 0) {
                if buttonBgColor == .green {
                    pinIsCreated = true
                    navigation.navigationStack.append(
                        Screens.securityQuestionView
                    )
                } 
               
            }
        }.padding()
        .onChange(of: confirmPin) { newValue in
            confirmPin = checkLength(newValue, length: 4)
            if confirmPin.isNotEmpty && confirmPin.elementsEqual(pin){
                isConfirmPinValid = true
            } else {
                isConfirmPinValid = false
            }
            updateButtonOnNewvalue(newValue: newValue, other: pin)
        }
        .onChange(of: pin) { newValue in
            pin = checkLength(newValue, length: 4)
            if newValue.isEmpty {
                isValid = false
            } else {
                isValid = true
            }
            updateButtonOnNewvalue(newValue: newValue, other: confirmPin)
        }
        .onChange(of: pinPermission) { newValue in
            validateAllFields()
        }
        .onAppear {
            validateAllFields()
        }
    }
    
    private func validateAllFields() {
        if isValid && isConfirmPinValid && !pinPermission.isEmpty {
            buttonBgColor = .green
        } else {
            buttonBgColor = .gray.opacity(0.5)
        }
    }
    private func updateButtonOnNewvalue(newValue: String, other: String) {
        if newValue.elementsEqual(other) && !pinPermission.isEmpty {
            buttonBgColor = .green
        } else {
            buttonBgColor = .gray.opacity(0.5)
        }
    }
}

struct CheckoutCardPinView_Previews: PreviewProvider {

    struct CheckoutCardPreviewHolder: View {
        @State var pin: String = ""
        @State var confirmPin: String = ""
        @State var pinPermission1 = ""
        @State var pinIsCreated: Bool = false
        var body: some View {
            CreditCardPinView(pinPermission: $pinPermission1, pin: $pin, confirmPin: $confirmPin, pinIsCreated: $pinIsCreated)
        }
    }
    static var previews: some View {
        CheckoutCardPreviewHolder()
            .environmentObject(NavigationUtils())
    }
}
