//
//  AddNewDebitOrCreditCardButton.swift
//  
//
//  Created by Abdulrasaq on 09/01/2023.
//

import SwiftUI

struct AddNewDebitOrCreditCardButton: View {
    let addANewCardString = "Add a new card"
    var onclick: () -> Void = {
        //TODO
    }
    var body: some View {
        HStack {
            Image(systemName: "plus")
            Text(addANewCardString)
                .textCase(.uppercase)
                .foregroundColor(.black)
        }.onTapGesture {
            onclick()
        }
    }
}

struct AddNewDebitOrCreditCardButton_Previews: PreviewProvider {
    static var previews: some View {
        AddNewDebitOrCreditCardButton()
    }
}
