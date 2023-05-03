//
//  PaymentOptionsView.swift
//  
//
//  Created by Abdulrasaq on 28/04/2023.
//
import Core
import CoreUI
import SwiftUI

struct PaymentOptionsView: View {
    private var headerText = "Tell us which payement options you would like to use on Tingg"
    @StateObject private var hvm = HomeDI.createHomeViewModel()
    var body: some View {
        VStack {
            Text(headerText)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            List($hvm.listOfPaymentOptions) { option in
                PaymentOptionItemView(
                    optionItem: option
                )
                .listRowInsets(EdgeInsets())
                .disabled(option.isDefault.wrappedValue)
            }.listStyle(PlainListStyle())
            TinggButton(buttonLabel: "Setup now") {
                //TODO
            }
        }
        .padding()
        .onAppear {
            let activePayers = Observer<MerchantPayer>().getEntities().filter {$0.activeStatus == "1"}
            hvm.listOfPaymentOptions = activePayers.map { mp in
                PaymentOptionItem(
                    optionName: mp.clientName ?? "",
                    isSelected: mp.isSelected?.convertStringToInt() == 1 ? true : false,
                    isDefault:  mp.isDefault == "1" ? true : false
                )
               
            }
        }
    }
}

struct PaymentOptionItemView: View {
    @Binding var optionItem: PaymentOptionItem
    var body: some View {
        HStack {
            Text(optionItem.optionName)
            Spacer()
            CheckBoxView(checkboxChecked: $optionItem.isSelected)
        }
        .onTapGesture {
            optionItem.isSelected.toggle()
            log(message: optionItem)
        }
    }
}

struct PaymentOptionItem: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var optionName: String = "Sample"
    var isSelected: Bool = false
    var isDefault: Bool = false
}

struct PaymentOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentOptionsView()
    }
}
