//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 07/12/2022.
//
import Theme
import SwiftUI
import Common
import Core
import Contacts
import Permissions


public struct BuyAirtimeCheckoutView: View {
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @State var selectedButton: String = "Diamond Trust Bank"
    @State var accountNumber = ""
    @State var title: String = "Buy Airtime"
    @State var amount: String = "Amount"
    @State var amountTextFieldPlaceHolder = "Enter amount"
    @State var selectPaymentTitle = "Select payment method"
    @State var someoneElsePaying = false
    @State var history: [TransactionHistory] = sampleTransactions
    @EnvironmentObject var checkout: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @State var providerDetails: [ProviderDetails] = .init()
    @State var networkId = "1"
    @State var historyByAccountNumber: [String] = .init()
    public init () {
        //
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text(title)
                        .frame(alignment: .center)
                        .padding(.vertical)
                    Spacer()
                    IconImageCardView(
                        imageUrl: checkout.service.serviceLogo,
                        radius: 50,
                        scaleEffect: 0.7
                    )
                }
                TextFieldView(fieldText: $amount, label: amount, placeHolder: amountTextFieldPlaceHolder)
//                SuggestedAmountListView(
//                    selectedServiceName: $selectedButton,
//                    amount: $amount,
//                    accountNumber: $accountNumber,
//                    historyByAccountNumber: $historyByAccountNumber
//                ).padding(.top)
                .hideIf(isHidden: .constant(false))

//                ProvidersListView(selectedProvider: $checkout.selectedMerchantPayerName, details: $providerDetails, canOthersPay: $checkout.isSomeoneElsePaying) {}

                Divider()
                Toggle("Ask someone else to pay", isOn:  $checkout.isSomeoneElsePaying)
                    .toggleStyle(SwitchToggleStyle(tint: PrimaryTheme.getColor(.primaryColor)))
                Divider()
                TextFieldAndRightIcon(
                    number: $contactViewModel.selectedContact
                ) {
                    Task {
                        await contactViewModel.fetchPhoneContacts { err in
                            hvm.uiModel = UIModel.error(err.localizedDescription)
                        }
                    }
                }.disabled(checkout.isSomeoneElsePaying ? false : true)
            }.padding(.horizontal)
            Spacer()
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Buy airtime"
            ) {

            }
        }
        .onAppear {
            providerDetails = Observer<MerchantPayer>().getEntities()
                .filter{$0.activeStatus != "0"}.map {
                    ProviderDetails(payer: $0)
            }
            let amount = history.filter {
                ($0.accountNumber == accountNumber && $0.serviceName == selectedButton)
            }.map {$0.amount}
            let uniqueAmount = Set(amount).sorted(by: <)
            historyByAccountNumber = uniqueAmount
        }
    }
}

struct BuyAirtimeCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        BuyAirtimeCheckoutView()
            .environmentObject(CheckoutViewModel())
            .environmentObject(ContactViewModel())
    }
}
