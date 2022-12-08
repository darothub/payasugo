//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 07/12/2022.
//

import SwiftUI
import Common
import Core

struct BuyAirtimeCheckoutView: View {
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @State var selectedButton: String = ""
    @State var accountNumber = ""
    @State var title: String = "Buy Airtime"
    @State var amount: String = "Amount"
    @State var amountTextFieldPlaceHolder = "Enter amount"
    @State var selectPaymentTitle = "Select payment method"
    var history: [TransactionHistory] {
        hvm.transactionHistory.getEntities()
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical)
            TextFieldView(fieldText: $amount, label: amount, placeHolder: amountTextFieldPlaceHolder)
            SuggestedAmountListView(
                history: history,
                selectedServiceName: $selectedButton,
                amount: $amount,
                accountNumber: $accountNumber
            ).padding(.top)
            Text(selectPaymentTitle)
//            AirtimeProviderListView(
//                selectedProvider: $selectedButton,
//                airtimeProviders: $hvm.airTimeServices,
//                defaultNetworkId: $hvm.defaultNetworkServiceId
//            ){
//
//            }
        }
    }
}

struct BuyAirtimeCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        BuyAirtimeCheckoutView()
    }
}
