//
//  CreditCardPinView.swift
//
//
//  Created by Abdulrasaq on 10/01/2023.
//

import CoreUI
import CoreNavigation
import Core
import SwiftUI


public struct EnterPinFullScreenView: View {
    @StateObject var pinVm = PinDI.createPinViewModel()
    @EnvironmentObject var navigation: NavigationManager
    @Environment(\.dismiss) var dismiss
    private let instruction = "Enter and confirm your pin below"
    private let pinPermission1 = PinConstants.pinRequestChoice1
    private let pinPermission2 = PinConstants.pinRequestChoice2
    @State var pinPermission: String = ""
    @State var pin: String = ""
    @State var confirmPin: String = ""
    @State var pinIsCreated: Bool = false
    @State private var buttonBgColor: Color = .gray.opacity(0.5)
    @State private var isPinValid = false
    @State private var isConfirmPinValid = false
    @FocusState var focus: Int?
    private var pinFieldPlaceHolder = "Enter pin"
    private var confirmPinFieldPlaceHolder = "Confirm pin"
    public init() {
        //
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Text(instruction)
            SecureTextFieldView(fieldText: $pin, label: "", placeHolder: pinFieldPlaceHolder, keyboardType: .numberPad) { str in
                if str.count == 4 {
                    focus = 1
                }
                DispatchQueue.main.async {
                    isPinValid = validatePinFields(str)
                }
                return isPinValid
            }.focused($focus, equals: 0)
            SecureTextFieldView(fieldText: $confirmPin, label: "", placeHolder: confirmPinFieldPlaceHolder, keyboardType: .numberPad) {  str in
                DispatchQueue.main.async {
                    isConfirmPinValid = validateConfirmPinFields(str)
                }
                return isConfirmPinValid
            }.focused($focus, equals: 1)
            HRadioButtonAndText(selected: $pinPermission, name: pinPermission1)
                .font(.caption)
                .padding(.vertical)
            HRadioButtonAndText(selected: $pinPermission, name: pinPermission2)
                .font(.caption)
            Spacer()
            TinggButton(backgroundColor: buttonBgColor, buttonLabel: "Continue", padding: 0) {
                if buttonBgColor == .green {
                    AppStorageManager.pinRequestChoice = pinPermission
                    navigation.navigateTo(screen: PinScreen.securityQuestionView(pin))
                }
               
            }
        }
        .padding()
        .onChange(of: pinPermission) { newValue in
            updateButtonOnNewvalue()
        }
        .onAppear {
            pinPermission = AppStorageManager.pinRequestChoice
        }
    }
    
    private func validatePinFields(_ newValue: String) -> Bool {
        pin = checkLength(newValue, length: 4)
        updateButtonOnNewvalue()
        if newValue.isEmpty {
            return false
        } else if pin.count == 4{
            return true
        }
    
        return false
    }
    private func validateConfirmPinFields(_ newValue: String) -> Bool {
        confirmPin = checkLength(newValue, length: 4)
        updateButtonOnNewvalue()
        if newValue.isEmpty {
            return false
        } else if confirmPin.count == 4 && confirmPin.elementsEqual(pin){
            return true
        }
    
        return false
    }
    private func updateButtonOnNewvalue() {
        if isPinValid && isConfirmPinValid && !pinPermission.isEmpty {
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
            EnterPinFullScreenView()
        }
    }
    static var previews: some View {
        CheckoutCardPreviewHolder()
            .environmentObject(NavigationManager())
    }
}
