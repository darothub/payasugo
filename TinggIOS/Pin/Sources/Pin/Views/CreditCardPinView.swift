//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 10/01/2023.
//

import Common
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
            SecureTextFieldView(fieldText: $pin, label: "", placeHolder: "Enter pin")
            SecureTextFieldView(fieldText: $confirmPin, label: "", placeHolder: "Confirm pin")
            HRadioButtonAndText(selected: $pinPermission, name: pinPermission1)
                .font(.caption)
                .padding(.vertical)
            HRadioButtonAndText(selected: $pinPermission, name: pinPermission2)
                .font(.caption)
            Spacer()
            button(backgroundColor: buttonBgColor, buttonLabel: "Continue", padding: 0) {
                if buttonBgColor == .green {
                    pinIsCreated = true
                    navigation.navigationStack.append(.securityQuestionView)
                } 
               
            }
        }.padding()
        .onChange(of: confirmPin) { newValue in
            confirmPin = checkLength(newValue, length: 4)
            if newValue.elementsEqual(pin) && !pinPermission.isEmpty {
                buttonBgColor = .green
            } else {
                buttonBgColor = .gray.opacity(0.5)
            }
        }
        .onChange(of: pin) { newValue in
            pin = checkLength(newValue, length: 4)
            if newValue.elementsEqual(confirmPin) && !pinPermission.isEmpty {
                buttonBgColor = .green
            } else {
                buttonBgColor = .gray.opacity(0.5)
            }
        }
        .onChange(of: pinPermission) { newValue in
            if pin.elementsEqual(confirmPin) && !newValue.isEmpty {
                buttonBgColor = .green
            } else {
                buttonBgColor = .gray.opacity(0.5)
            }
        }
        .onAppear {
            if !pin.isEmpty && pin.elementsEqual(confirmPin) && !pinPermission.isEmpty {
                buttonBgColor = .green
            } else {
                buttonBgColor = .gray.opacity(0.5)
            }
        }
    }
    func isDetailsValidate() {
        
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
