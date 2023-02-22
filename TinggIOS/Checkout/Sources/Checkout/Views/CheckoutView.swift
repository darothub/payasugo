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
    @State private var selectedButton: String = "Diamond Trust Bank"
    @State private var accountNumber = ""
    @State private var title: String = "Buy Airtime"
    @State private var amount: String = "Amount"
    @State private var amountTextFieldPlaceHolder = "Enter amount"
    @State private var selectPaymentTitle = "Select payment method"
    @State private var someoneElseIsPaying = false
    @State private var history: [TransactionHistory] = sampleTransactions
    @State private var providerDetails: [ProviderDetails] = .init()
    @State private var networkId = "1"
    @State private var historyByAccountNumber: [String] = .init()
    @State private var showCardPinView = false
    @State private var pin: String = ""
    @State private var confirmPin: String = ""
    @State private var createdPin = false
    @State private var pinIsCreated: Bool = false
    @State private var showSecurityQuestionView = false
    @State private var questions:[String] = .init()
    @State private var selectedQuestion:String = ""
    @State private var showingDropDown = false
    @State private var selectedAccount:String = ""
    @State private var accountList = [String]()
    @State private var isQuickTopUpOrAirtime = false
    @State private var selectedPayer: MerchantPayer = .init()
    @State private var buttonText = "Pay"
    @State private var showDTBPINDialog = false
    @State private var dtbAccounts = [DTBAccount]()
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
                buttonLabel: buttonText
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
                case MerchantPayer.CHECKOUT_IN_APP:
                    fetchCustomerDtbAccounts()
                default:
                    print("Default")
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
            //Observe FWC request
            checkoutVm.observeUIModel(model: checkoutVm.$fwcUIModel, subscriptions: &checkoutVm.subscriptions) { content in
                let response = content.data as! DTBAccountsResponse
                dtbAccounts = response.accounts ?? []
                showDTBPINDialog = true
            } onError: { err in
                log(message: err)
            }
            //Observe RINV Request
            checkoutVm.observeUIModel(model: checkoutVm.$raiseInvoiceUIModel, subscriptions: &checkoutVm.subscriptions) { content in
                let response = content.data as! RINVResponse
            } onError: { err in
                log(message: err)
            }
        
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
        .onChange(of: checkoutVm.suggestedAmountModel.amount, perform: { newValue in
            if checkoutVm.service.isAirtimeService {
                buttonText = "Buy \(checkoutVm.service.serviceName)"
            } else {
                buttonText = "Pay \(newValue)"
            }
        })
        .customDialog(isPresented: $showDTBPINDialog) {
            DTBCheckoutDialogView(imageUrl: selectedPayer.logo!, dtbAccounts: dtbAccounts) {
                pin in
                PayerChargeCalculator.checkCharges(merchantPayer: selectedPayer, merchantService: checkoutVm.service, amount: Double(checkoutVm.suggestedAmountModel.amount) ?? 0.0)
            }
        }
        .handleViewStates(uiModel: $checkoutVm.raiseInvoiceUIModel, showAlert: .constant(true))
        .handleViewStates(uiModel: $checkoutVm.fwcUIModel, showAlert: .constant(true))
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
        let _ = Observer<ManualBill>().getEntities()
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
    private func getPayingMSISDN() -> String {
        checkoutVm.isSomeoneElsePaying ? checkoutVm.favouriteEnrollmentListModel.accountNumber : AppStorageManager.getPhoneNumber()
    }
    
    private func fetchCustomerDtbAccounts() {
        let request = RequestMap.Builder()
            .add(value: selectedPayer.hubClientID, for: "PAYER_CLIENT_ID")
            .add(value: "FWC", for: .SERVICE)
            .build()
        checkoutVm.makeFWCRequest(request: request)
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


