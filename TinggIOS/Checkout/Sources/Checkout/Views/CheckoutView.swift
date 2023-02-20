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


public struct CheckoutView: View {
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var navigation: NavigationUtils
    @Environment(\.dismiss) var dismiss
    @State var selectedButton: String = "Diamond Trust Bank"
    @State var accountNumber = ""
    @State var title: String = "Buy Airtime"
    @State var amount: String = "Amount"
    @State var amountTextFieldPlaceHolder = "Enter amount"
    @State var selectPaymentTitle = "Select payment method"
    @State var someoneElseIsPaying = false
    @State var history: [TransactionHistory] = sampleTransactions
    @State var providerDetails: [ProviderDetails] = .init()
    @State var networkId = "1"
    @State var historyByAccountNumber: [String] = .init()
    @State var showCardPinView = false
    @State var pin: String = ""
    @State var confirmPin: String = ""
    @State var createdPin = false
    @State var pinIsCreated: Bool = false
    @State var showSecurityQuestionView = false
    @State var questions:[String] = .init()
    @State var selectedQuestion:String = ""
    @State private var showingDropDown = false
    @State var selectedAccount:String = ""
    @State var accountList = [String]()
    @State var isQuickTopUpOrAirtime = false
    @State var selectedPayer: MerchantPayer = .init()
    public init () {
        //
    }
    public var body: some View {
        VStack(alignment: .center) {
            Section {
                HStack {
                    Text(title)
                        .frame(alignment: .center)
                        .padding(.vertical)
                        .bold()
                    Spacer()
                    IconImageCardView(
                        imageUrl: checkoutVm.service.serviceLogo,
                        radius: 50,
                        scaleEffect: 0.7
                    )
                }
                DropDownView(selectedText: $selectedAccount, dropDownList: $accountList, showDropDown: $showingDropDown
                ).showIf($isQuickTopUpOrAirtime)
                Group {
                    AmountAndCurrencyTextField(
                        amount: $checkoutVm.suggestedAmountModel.amount,
                        currency: $checkoutVm.suggestedAmountModel.currency
                    ).disabled(checkoutVm.service.canEditAmount == "0" ? true : false)
                    
                    SuggestedAmountListView(
                        accountNumberHistory: $checkoutVm.suggestedAmountModel.historyByAccountNumber,
                        amountSelected: $checkoutVm.suggestedAmountModel.amount
                    ).padding(.top)
                    MerchantPayerListView(
                        plm: $checkoutVm.providersListModel
                    ) {
                        checkoutVm.favouriteEnrollmentListModel.accountNumber = ""
                    }
                }.showIfNot($showingDropDown)
            
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
                    number: $checkoutVm.favouriteEnrollmentListModel.accountNumber
                ) {
                    Task {
                        await contactViewModel.fetchPhoneContacts { err in
                            checkoutVm.uiModel = UIModel.error(err.localizedDescription)
                        }
                    }
                }.disabled(checkoutVm.isSomeoneElsePaying ? false : true)
                .showIf($someoneElseIsPaying)
            }.padding(.horizontal)
            .showIf($checkoutVm.isSomeoneElsePaying)
            .showIfNot($showingDropDown)
            Group {
                DebitCardDropDownView(dcddm: $checkoutVm.dcddm)
                    .padding()
                    .showIf($checkoutVm.showCardOptions)
                    .showIf(.constant(checkoutVm.dcddm.cardDetails.isNotEmpty()))
                AddNewDebitOrCreditCardButton() {
                    dismiss()
                    checkoutVm.cardDetails.amount = checkoutVm.suggestedAmountModel.amount
                    navigation.navigationStack.append(.pinCreationView)
                }
                .showIf($checkoutVm.addNewCard)
                .padding(30)
            }.showIfNot($showingDropDown)
            
            Spacer()
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Pay \(checkoutVm.suggestedAmountModel.amount)"
            ) {
                let isValidated: Bool = validatePhoneNumberByCountry(AppStorageManager.getCountry(), phoneNumber: checkoutVm.favouriteEnrollmentListModel.accountNumber)
                if !isValidated {
                    checkoutVm.showAlert = true
                    checkoutVm.uiModel = UIModel.error("Invalid phone number")
                    return
                }
                let response = validateAmountByService(selectedService: checkoutVm.service, amount: checkoutVm.suggestedAmountModel.amount)
                if !response.isEmpty {
                    checkoutVm.showAlert = true
                    checkoutVm.uiModel = UIModel.error(response)
                    return
                }
                if let selectedPayer = checkoutVm.providersListModel.details.first(where: { p in
                    p.payer.clientName == checkoutVm.providersListModel.selectedProvider
                }){
                    self.selectedPayer = selectedPayer.payer
                }
                switch selectedPayer.checkoutType {
                case MerchantPayer.CHECKOUT_USSD_PUSH:
                    raiseInvoice()
                case .none:
                    print("None")
                case .some(_):
                    print("Some")
                }
            }
        }
        .sheet(isPresented: $contactViewModel.showContact) {
            showContactView(contactViewModel: contactViewModel)
        }
        .onAppear {
            checkoutVm.providersListModel.details = Observer<MerchantPayer>().getEntities()
                .filter{$0.activeStatus != "0"}.map {
                    ProviderDetails(payer: $0, othersCanPay: $0.canPayForOther  != "0" ? true : false)
            }
            questions = Observer<SecurityQuestion>().getEntities().map {$0.question}
            checkoutVm.cardDetails.amount = checkoutVm.suggestedAmountModel.amount
            accountList = checkoutVm.favouriteEnrollmentListModel.enrollments.compactMap {$0.accountNumber}
            isQuickTopUpOrAirtime = checkoutVm.service.isAirtimeService
            log(message: "\(checkoutVm.service)")
        }.onChange(of: checkoutVm.providersListModel) { model in
            someoneElseIsPaying = false
            checkoutVm.isSomeoneElsePaying = model.canOthersPay
           
            if model.selectedProvider == "Card" {
                let selectedDetails = model.details.first {$0.payer.clientName == model.selectedProvider}
                let listOfCards = getListOfCards(imageUrl: selectedDetails?.payer.logo ?? "")
                if listOfCards.isNotEmpty() {
                    checkoutVm.dcddm.selectedCardDetails = listOfCards[0]
                    checkoutVm.dcddm.cardDetails = listOfCards
                    checkoutVm.showCardOptions = true
                }
                checkoutVm.addNewCard = true
              
            } else {
                checkoutVm.showCardOptions = false
                checkoutVm.addNewCard = false
            }
        }
        .onChange(of: contactViewModel.selectedContact) { newValue in
            checkoutVm.favouriteEnrollmentListModel.accountNumber = newValue
        }
        .handleViewStates(uiModel: $checkoutVm.uiModel, showAlert: .constant(true))
    }
    func getListOfCards(imageUrl:String) -> [CardDetailDTO] {
        return Observer<Card>().getEntities().map { c in
             CardDetailDTO(cardAlias: c.cardAlias ?? "", payerClientID: c.payerClientID ?? "", cardType: c.cardType ?? "", activeStatus: c.activeStatus ?? "", logoUrl: imageUrl)
        }
    }
    func getAvailableInvoice() -> Invoice? {
       return Observer<Invoice>().getEntities().first(where: { invoice in
            checkoutVm.favouriteEnrollmentListModel.enrollments.first { e in
                e.clientProfileAccountID == invoice.enrollment?.clientProfileAccountID
            }?.accountNumber == checkoutVm.favouriteEnrollmentListModel.accountNumber
        })
    }
    func raiseInvoice() {
        let m = Observer<ManualBill>().getEntities()
        let profile = Observer<Profile>().getEntities().first
        let request = RequestMap.Builder()
            .add(value: "RINV", for: .SERVICE)
            .add(value: getPayingMSISDN(), for: .MSISDN)
            .add(value: checkoutVm.isSomeoneElsePaying, for: "IS_THIRD_PARTY_PAYMENT")
            .add(value: AppStorageManager.getPhoneNumber(), for: "ORIGINATOR_MSISDN")
            .add(value: checkoutVm.suggestedAmountModel.amount, for: .AMOUNT)
            .add(value: checkoutVm.service.hubServiceID, for: .SERVICE_ID)
            .add(value: "", for: .ACCOUNT_NUMBER)
            .add(value: getAvailableInvoice()?.invoiceNumber, for: "INVOICE_NUMBER")
            .add(value: checkoutVm.suggestedAmountModel.amount, for: "BILL_AMOUNT")
            .add(value: AppStorageManager.getCountry()?.currency, for: "CURRENCY")
            .add(value: "", for: "REWARD")
            .add(value: "ADD", for: .ACTION)
            .add(value: getAvailableInvoice()?.dueDate, for: "DUE_DATE")
            .add(value: "", for: "NARRATION")
            .add(value: getAvailableInvoice()?.estimateExpiryDate, for: "EXPIRY_DATE")
            .add(value: "", for: "PAYER_TRANSACTION_ID")
            .add(value: checkoutVm.service.serviceName, for: "SERVICE_NAME")
            .add(value: checkoutVm.service.serviceCode, for: "SERVICE_CODE")
            .add(value: selectedPayer.hubClientID, for: "PAYER_CLIENT_ID")
            .add(value: "", for: "PRODUCT_CODE")
            .add(value: "", for: "BEEP_TRANSACTION_ID")
            .add(value: "", for: "WALLET_DATA")
            .add(value: checkoutVm.service.hubClientID, for: "HUB_CLIENT_ID")
            .add(value: "", for: "PAYBILL")
            .add(value: getAvailableInvoice()?.callbackData, for: "CALLBACK_DATA")
            .add(value: getAvailableInvoice()?.billReference, for: "REFERENCE_NUMBER")
            .add(value: "1", for: "NOMINATE")
            .add(value: profile?.profileID, for: "PROFILE_ID")
            .add(value: "", for: "PIN")
            .add(value: selectedPayer.checkoutType, for: "CHECKOUT_TYPE")
            .add(value: "", for: "ACCOUNT_ID")
            .add(value: "", for: "ACCOUNT_ALIAS")
            .add(value: "1", for: "IS_APP_INVOICE")
            .add(value: "0", for: "CHECK_MODE")
            .add(value: "", for: "MERCHANT_TIER_CODE")
            .add(value: "", for: "BUNDLE_ID")
            .add(value: "", for: "PIN_CODE")
            .add(value: "", for: "MULA_PIN")
            .add(value: "", for: "EXTRA_DATA")
            .build()
        
        checkoutVm.raiseInvoiceRequest(request: request)
    }
    
    func getPayingMSISDN() -> String {
        checkoutVm.isSomeoneElsePaying ? checkoutVm.favouriteEnrollmentListModel.accountNumber : AppStorageManager.getPhoneNumber()
    }
}

struct BuyAirtimeCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
            .environmentObject(CheckoutDI.createCheckoutViewModel())
            .environmentObject(ContactViewModel())
            .environmentObject(NavigationUtils())
    }
}


