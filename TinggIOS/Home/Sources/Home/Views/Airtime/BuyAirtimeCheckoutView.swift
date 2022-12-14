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
    @State var selectedButton: String = ""
    @State var accountNumber = ""
    @State var title: String = "Buy Airtime"
    @State var amount: String = "Amount"
    @State var amountTextFieldPlaceHolder = "Enter amount"
    @State var selectPaymentTitle = "Select payment method"
    @State var someoneElsePaying = false
    @State var history: [TransactionHistory] = sampleTransactions
    @EnvironmentObject var checkout: Checkout
    @EnvironmentObject var contactViewModel: ContactViewModel
    @State var providerDetails: [ProviderDetails] = .init()
    @State var networkId = "1"
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
                    RemoteImageCard(imageUrl: checkout.service.serviceLogo)
                }
                TextFieldView(fieldText: $amount, label: amount, placeHolder: amountTextFieldPlaceHolder)
                SuggestedAmountListView(
                    history: history,
                    selectedServiceName: $selectedButton,
                    amount: $amount,
                    accountNumber: $accountNumber
                ).padding(.top)
                .hideIf(isHidden: .constant(false))
                
                ProvidersListView(selectedProvider: $selectedButton, details: $providerDetails, canOthersPay: $someoneElsePaying) {}

                Divider()
                Toggle("Ask someone else to pay", isOn: $someoneElsePaying)
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
                }
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
                .filter{$0.activeStatus == "1"}.map {
                    ProviderDetails(
                        logo: $0.logo ?? "",
                        name: $0.clientName ?? "None",
                        othersCanPay: $0.canPayForOther == "0" ? true : false
                    )
                }
        }
    }
}

struct BuyAirtimeCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        BuyAirtimeCheckoutView()
            .environmentObject(Checkout())
    }
}
