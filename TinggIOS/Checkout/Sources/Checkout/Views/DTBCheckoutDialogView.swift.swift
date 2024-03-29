//
//  DTBCheckoutDialogView.swift
//  
//
//  Created by Abdulrasaq on 20/02/2023.
//

import CoreUI
import Core
import SwiftUI
import Theme

struct DTBCheckoutDialogView: View {
    var imageUrl = ""
    var amount = "0"
    var accountName = ""
    var pinFieldInstruction = "Enter PIN"
    @State var dtbAccounts = [DTBAccount.sample1, DTBAccount.sample2]
    @State var selectedAccount = ""
    @State private var pin = ""
    @State private var listOfAccountIsNotEmpty = false
    @State private var showPINField = false
    @State private var isValidPin = false
    @State var onDTBPINEntered: (String) -> Void = {_ in
        //TODO
    }
    var body: some View {
        VStack {
            IconImageCardView(imageUrl: imageUrl)
            VStack(alignment: .leading) {
                Text("Select account")
                showDTBAccount()
                pinSection()
            }
            TinggButton(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Pay"
            ) {
                let encryptedPin = handlePINValidation(pin: pin)
                onDTBPINEntered(encryptedPin)
            }
        }
        .padding()
        .onChange(of: selectedAccount, perform: { newValue in
            if newValue.isNotEmpty {
                withAnimation {
                    showPINField = true
                }
            }
        })
        .onChange(of: pin, perform: { newValue in
            _ = handlePINValidation(pin: newValue)
        })
        .onAppear {
            listOfAccountIsNotEmpty = dtbAccounts.isNotEmpty()
        }
    }
    @ViewBuilder
    private func pinSection() -> some View {
        Section {
            Text("Enter PIN for account \(selectedAccount)")
            TextFieldView(fieldText: $pin, label: "", placeHolder: pinFieldInstruction){ str in
                str.isNotEmpty
            }
        }.showIf($showPINField)
    }
    @ViewBuilder
    private func showDTBAccount() -> some View {
        ForEach(dtbAccounts, id: \.accountId) { account in
            if let label = account.alias {
                RadioButtonWithTextView(id: label, selected: $selectedAccount, label: label)
            }
        }.showIf($listOfAccountIsNotEmpty)
    }
    private func handlePINValidation(pin: String) -> String {
        if pin.isNotEmpty {
            isValidPin = true
        } else {
            isValidPin = false
        }
       return CreditCardUtil.encrypt(data: pin)
    }
}


struct DTBCheckoutDialogView_Previews: PreviewProvider {
    static var previews: some View {
        DTBCheckoutDialogView()
    }
}
