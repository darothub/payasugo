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
    @StateObject var bavm = BuyAirtimeViewModel()
    @State var selectedButton: String = "Diamond Trust Bank"
    @State var accountNumber = ""
    @State var title: String = "Buy Airtime"
    @State var amount: String = "Amount"
    @State var amountTextFieldPlaceHolder = "Enter amount"
    @State var selectPaymentTitle = "Select payment method"
    @State var someoneElseIsPaying = false
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
                TextFieldView(fieldText: $bavm.suggestedAmountModel.amount, label: amount, placeHolder: amountTextFieldPlaceHolder)
                SuggestedAmountListView(
                    sam: $bavm.suggestedAmountModel
                ).padding(.top)
                
                MerchantPayerListView(
                    plm: $bavm.providersListModel
                ) {
                    bavm.favouriteEnrollmentListModel.accountNumber = ""
                }

                Toggle("Ask someone else to pay", isOn:  $someoneElseIsPaying)
                    .toggleStyle(SwitchToggleStyle(tint: PrimaryTheme.getColor(.primaryColor)))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                           
                    )
                    .showIf($checkout.isSomeoneElsePaying)
                TextFieldAndRightIcon(
                    number: $contactViewModel.selectedContact
                ) {
                    Task {
                        await contactViewModel.fetchPhoneContacts { err in
                            hvm.uiModel = UIModel.error(err.localizedDescription)
                        }
                    }
                }.disabled(checkout.isSomeoneElsePaying ? false : true)
                .showIf($someoneElseIsPaying)
            }.padding(.horizontal)
            Spacer()
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Buy airtime"
            ) {

            }
        }
        .onAppear {
            bavm.providersListModel.details = Observer<MerchantPayer>().getEntities()
                .filter{$0.activeStatus != "0"}.map {
                    ProviderDetails(payer: $0, othersCanPay: $0.canPayForOther  != "0" ? true : false)
            }
            let amount = hvm.transactionHistory.getEntities().filter {
                ($0.accountNumber == checkout.accountNumber && $0.serviceName == checkout.service.serviceName)
            }.map {$0.amount}
            let uniqueAmount = Set(amount).sorted(by: <)
            contactViewModel.selectedContact = checkout.accountNumber
            bavm.suggestedAmountModel.historyByAccountNumber = uniqueAmount
            print("Amount \(checkout.amount)")
            bavm.suggestedAmountModel.amount = String(checkout.amount)
        }
        .onChange(of: bavm.providersListModel) { model in
            checkout.isSomeoneElsePaying = model.canOthersPay
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
