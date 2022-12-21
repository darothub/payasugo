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
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @State var providerDetails: [ProviderDetails] = .init()
    @State var networkId = "1"
    @State var historyByAccountNumber: [String] = .init()
    public init () {
        //
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Section {
                HStack {
                    Text(title)
                        .frame(alignment: .center)
                        .padding(.vertical)
                        .bold()
                    Spacer()
                    IconImageCardView(
                        imageUrl: checkoutVm.cm.service.serviceLogo,
                        radius: 50,
                        scaleEffect: 0.7
                    )
                }
                AmountAndCurrencyTextField(
                    amount: $bavm.suggestedAmountModel.amount,
                    currency: $checkoutVm.cm.currency
                ).disabled(checkoutVm.cm.service.canEditAmount == "0" ? true : false)

                SuggestedAmountListView(
                    sam: $bavm.suggestedAmountModel
                ).padding(.top)
                
                MerchantPayerListView(
                    plm: $bavm.providersListModel
                ) {
                    bavm.favouriteEnrollmentListModel.accountNumber = ""
                }
            }.padding(.horizontal)
            Section {
                Toggle("Ask someone else to pay", isOn:  $someoneElseIsPaying)
                    .toggleStyle(SwitchToggleStyle(tint: PrimaryTheme.getColor(.primaryColor)))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                           
                    )
                TextFieldAndRightIcon(
                    number: $checkoutVm.cm.accountNumber
                ) {
                    Task {
                        await contactViewModel.fetchPhoneContacts { err in
                            hvm.uiModel = UIModel.error(err.localizedDescription)
                        }
                    }
                }.disabled(checkoutVm.cm.isSomeoneElsePaying ? false : true)
                .showIf($someoneElseIsPaying)
            }.padding(.horizontal)
                .showIf($checkoutVm.cm.isSomeoneElsePaying)
            DebitCardDropDownView(dcddm: $bavm.dcddm)
                .padding()
                .showIf($bavm.showCardOptions)
            Spacer()
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Buy airtime"
            ) {
                let isValidated = checkoutVm.validatePhoneNumberByCountry(hvm.country, phoneNumber: checkoutVm.cm.accountNumber)
                if !isValidated {
                    hvm.showAlert = true
                    hvm.uiModel = UIModel.error("Invalid phone number")
                }
                let response = checkoutVm.validateAmountByService(selectedService: checkoutVm.cm.service, amount: checkoutVm.cm.amount)
                if !response.isEmpty {
                    hvm.showAlert = true
                    hvm.uiModel = UIModel.error(response)
                }
            }
        }
        .sheet(isPresented: $contactViewModel.showContact) {
            showContactView(contactViewModel: contactViewModel)
        }
        .onAppear {
            print("Canedit \(checkoutVm.cm.service.canEditAmount )")
            bavm.providersListModel.details = Observer<MerchantPayer>().getEntities()
                .filter{$0.activeStatus != "0"}.map {
                    ProviderDetails(payer: $0, othersCanPay: $0.canPayForOther  != "0" ? true : false)
            }
            let amount = hvm.transactionHistory.getEntities().filter {
                ($0.accountNumber == checkoutVm.cm.accountNumber && $0.serviceName == checkoutVm.cm.service.serviceName)
            }.map {$0.amount}
            let uniqueAmount = Set(amount).sorted(by: <)
            contactViewModel.selectedContact = checkoutVm.cm.accountNumber
            bavm.suggestedAmountModel.historyByAccountNumber = uniqueAmount
            bavm.suggestedAmountModel.amount = String(checkoutVm.cm.amount)
            bavm.suggestedAmountModel.currency = checkoutVm.cm.currency
        }
        .onChange(of: bavm.providersListModel) { model in
            someoneElseIsPaying = false
            checkoutVm.cm.isSomeoneElsePaying = model.canOthersPay
           
            if model.selectedProvider == "Card" {
                let selectedDetails = model.details.first {$0.payer.clientName == model.selectedProvider}
                let listOfCards = getListOfCards(imageUrl: selectedDetails?.payer.logo ?? "")
                bavm.dcddm.selectedCardDetails = listOfCards[0]
                bavm.dcddm.cardDetails = listOfCards
                bavm.showCardOptions = true
            } else {
                bavm.showCardOptions = false
            }
        }
        .onChange(of: contactViewModel.selectedContact) { newValue in
            checkoutVm.cm.accountNumber = newValue
        }
        .handleViewStates(uiModel: $hvm.uiModel, showAlert: $hvm.showAlert)
    }
    func getListOfCards(imageUrl:String) -> [CardDetailDTO] {
        return Observer<Card>().getEntities().map { c in
             CardDetailDTO(cardAlias: c.cardAlias ?? "", payerClientID: c.payerClientID ?? "", cardType: c.cardType ?? "", activeStatus: c.activeStatus ?? "", logoUrl: imageUrl)
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
