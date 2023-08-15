//
//  AmountAndCurrencyTextField.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//

import SwiftUI


public struct AmountAndCurrencyTextField: View {
    @Binding var amount: String
    @Binding var currency: String
    public init(amount: Binding<String>, currency: Binding<String>) {
        self._amount = amount
        self._currency = currency
    }
    public var body: some View {
        HStack {
            Text(currency)
                .bold()
            TextField("Enter amount", text: $amount)
                .keyboardType(.numberPad)
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
        ).foregroundColor(.black)
    }
}
