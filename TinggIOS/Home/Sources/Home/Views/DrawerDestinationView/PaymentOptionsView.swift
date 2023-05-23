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
    @State var paymentOptions =  [
        PaymentOptionItem(optionName: "Mpesa", isSelected: false),
        PaymentOptionItem(optionName: "Viusasa", isSelected: false)
    ]

    var body: some View {
        VStack {
            Text(headerText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundmode(color: .black)
            List($paymentOptions) { option in
                PaymentOptionItemView(
                    optionItem: option
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.white)
                .padding(.vertical, 30)
                .padding(.horizontal, 5)
                .disabled(option.isDefault.wrappedValue)
            }
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
            .listStyle(PlainListStyle())
            .backgroundmode(color: .white)
            .scrollContentBackground(.hidden)
            TinggButton(buttonLabel: "Setup now") {
                //TODO
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundmode(color: .white)
        .onAppear {
            let activePayers = Observer<MerchantPayer>().getEntities().filter {$0.activeStatus == "1"}
            let options = activePayers.map { mp in
                PaymentOptionItem(
                    optionName: mp.clientName ?? "None",
                    isSelected: mp.isSelected?.convertStringToInt() == 1 ? true : false,
                    isDefault:  mp.isDefault == "1" ? true : false
                )
               
            }
            paymentOptions.removeAll()
            paymentOptions.append(contentsOf: options)
        }
    }
}

struct PaymentOptionItemView: View {
    @Binding var optionItem: PaymentOptionItem
    var body: some View {
        HStack {
            Text(optionItem.optionName)
                .foregroundmode(color: .black)
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
