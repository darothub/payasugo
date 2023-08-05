//
//  CheckoutView.swift
//  
//
//  Created by Abdulrasaq on 07/12/2022.
//
import Theme
import SwiftUI
import CoreUI
import CoreNavigation
import Core
import Combine
import Contacts
import Permissions
import Pin

public struct CheckoutView: View, OnPINTextFieldListener, OnEnterPINListener {
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var navigation: NavigationManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.realmManager) var realmManager
    @StateObject var pinDialogVm = PinDialogViewModel()
    @State private var selectedButton: String = "Diamond Trust Bank"
    @State private var accountNumber = ""
    @State private var title: String = ""
    @State private var amount: String = "Amount"
    @State private var amountTextFieldPlaceHolder = "Enter amount"
    @State private var selectPaymentTitle = "Select payment method"
    @State private var someoneElseIsPaying = false
    @State private var history: [TransactionHistory] = sampleTransactions
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
    @State private var encryptePIN = ""
    @State private var showPinView = false
    @State private var showAlert = false
    @State private var showAlertOnSuccess = false
    @State private var showAlertForPin = false
    @State private var showAlertForRINV = true
    @State private var showAlertForFWC = false
    @State private var currency = ""
    @State private var selectedService: MerchantService = sampleServices[0]
    @State var allRecharges = [String: [MerchantService]]()
    @State private var isValidPhoneNumber = false
    @State private var isValidAmount = false
    @State private var isValidSomeoneElsePhoneNumber = false
    @State var showPinDialog = false
    @State var showContact = false
    @State var nextActionAfterPinInput = ""
    let profile = Observer<Profile>().getEntities().first
    @FocusState var focused: String?
    let listener: CheckoutListener
    public init (listener: CheckoutListener) {
        self.listener = listener
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            HorizontalLogoAndServiceName()
            HStack(alignment: .bottom) {
                DropDownView(
                    selectedText: $checkoutVm.currentAccountNumber,
                    dropDownList: $checkoutVm.accountList,
                    showDropDown: $showingDropDown,
                    maxHeight: .infinity
                ).disabled(checkoutVm.accountList.isEmpty)
                Image(systemName: "plus")
                    .padding(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                    ) .background(.white)
                    .foregroundColor(.black)
                    .onTapGesture {
                        listener.onAddNewBillClick()
                    }
            }
            TextFieldAndLeftTitle(
                number: $checkoutVm.selectedAmount,
                iconName: checkoutVm.currency,
                placeHolder: "Enter amount",
                keyboardType: .numberPad
            ) { amount in
                isValidAmount = validateAmountByService(selectedService: checkoutVm.currentService, amount: amount)
               return isValidAmount
            }.focused($focused, equals: checkoutVm.selectedAmount)
            PaymentDetailView()
                .showIfNot($showingDropDown)
            Toggle(
                "Ask someone else to pay",
                isOn:  $checkoutVm.isSomeoneElsePaying
            )
            .toggleStyle(
                SwitchToggleStyle(
                    tint: PrimaryTheme.getColor(.primaryColor)
                )
            )
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.5)
            )
            .foregroundColor(.black)
            TextFieldAndRightIcon(
                number: $checkoutVm.phoneNumber,
                validation: { phoneNumber in
                    isValidSomeoneElsePhoneNumber = validateWithRegex(checkoutVm.countryMobileRegex, value: phoneNumber)
                    return isValidSomeoneElsePhoneNumber
                    
                },
                onImageClick:  {
                    showContact = true
                })
                .disabled(
                    checkoutVm.isSomeoneElsePaying ? false : true
                )
                .showIf($checkoutVm.isSomeoneElsePaying)
                .focused(
                    $focused, equals: checkoutVm.currentAccountNumber
                )
                .showIf($checkoutVm.canPayForOthers)
                .showIfNot($showingDropDown)
            
            CardDropDownView()
            //MARK: Button
            TinggButton(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: buttonText
            ) {
                onButtonClick()
            }
            .focused($focused, equals: nil)
        }
        .padding(.horizontal, 10)
        .attachEnterPinDialog(showPinDialog: $showPinDialog, pin: pin, onFinish: $nextActionAfterPinInput, listener: self)
        .showContactModifier($showContact, completion: { contact in
            checkoutVm.phoneNumber = contact.phoneNumber
        }, onFailure: { err in
            checkoutVm.uiModel = UIModel.error(err)
        })
        .toolbar {
            handleKeyboardDone()
        }
        .onAppear {
            setPaymentServiceProviderModelFromServices(checkoutVm.paymentServiceProviders)
            setCheckoutTitle()

            questions = Observer<SecurityQuestion>().getEntities().map {$0.question}
//                checkoutVm.cardDetails.amount = checkoutVm.sam.amount
            checkoutVm.accountList = checkoutVm.enrollments.compactMap {$0.accountNumber}
            isQuickTopUpOrAirtime = selectedService.isAirtimeService
            updateButtonLabel()
            checkoutVm.phoneNumber = AppStorageManager.getPhoneNumber()
            
        }
        .onChange(of: checkoutVm.slm) { model in
            checkoutVm.currentPaymentProvider = checkoutVm.paymentServiceProviders.first {$0.clientName == checkoutVm.slm.selectedProvider}!
            checkoutVm.canPayForOthers = checkoutVm.currentPaymentProvider.canPayForOther == "0" ? false : true
            if checkoutVm.currentPaymentProvider.checkoutType == MerchantPayer.CHECKOUT_CARD {
                let listOfCards = createListOfCards(imageUrl: checkoutVm.currentPaymentProvider.logo ?? "")
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
        .onChange(of: checkoutVm.selectedAmount, perform: { newValue in
            buttonText = "Pay \(newValue)"
        })
        .onChange(of: checkoutVm.currentAccountNumber) { newValue in
            let exitingInvoice = checkoutVm.invoices.first { invoice in
                 invoice.billReference == checkoutVm.currentAccountNumber
             }
             checkoutVm.selectedAmount = exitingInvoice?.amount ?? ""
        }
        .customDialog(isPresented: $showDTBPINDialog) {
            DTBCheckoutDialogView(imageUrl: selectedPayer.logo!, dtbAccounts: dtbAccounts) {
                pin in
                encryptePIN = pin
                raiseInvoice()
            }
        }
        .handleViewStatesMods(uiState: checkoutVm.$validatePinUImodel) { content in
            _ = content.data as! BaseDTO
            dismiss()
            showPinDialog = false
            listener.onAddNewCardClick()
        }
        .handleViewStatesMods(uiState: checkoutVm.$raiseInvoiceUIModel){ content in
            let response = content.data as! RINVResponse
            let invoice = response.raisedInvoice[0]
            let transaction = TransactionHistory()
            transaction.beepTransactionID = "\(invoice.beepTransactionID)"
            transaction.accountNumber = invoice.accountNumber
            transaction.amount = invoice.amount
            transaction.serviceCode = checkoutVm.currentService.serviceCode
            transaction.paymentDate = Date.now.dateToString()
            transaction.clientCode =  checkoutVm.currentPaymentProvider.clientCode!
            transaction.payerClientID =  checkoutVm.currentPaymentProvider.hubClientID
            transaction.serviceID = checkoutVm.currentService.hubServiceID
            transaction.serviceName = checkoutVm.currentService.serviceName
            transaction.status = "pending"
            transaction.serviceLogo = checkoutVm.currentService.serviceLogo
            transaction.requestOrigin = "MULA_APP"
            transaction.msisdn = checkoutVm.myPhoneNumber
            transaction.currencyCode = checkoutVm.currency
            realmManager.save(data: transaction)
            listener.onCheckoutSuccess(checkoutType: MerchantPayer.CHECKOUT_USSD_PUSH, response: response)
        } action: {
            listener.navigateToInvoicePage()
        }
        .handleViewStatesMods(uiState: checkoutVm.$fwcUIModel) { content in
            let response = content.data as! DTBAccountsResponse
            dtbAccounts = response.accounts ?? []
            showDTBPINDialog = true
            listener.onCheckoutSuccess(checkoutType: MerchantPayer.CHECKOUT_IN_APP, response: response)
        }
        .handleViewStatesMods(uiState: checkoutVm.$uiModel) { content in
            let response = content.data as! CreateCardChannelResponse
            checkoutVm.cardDetails.checkout = true
            listener.onCheckoutSuccess(checkoutType: MerchantPayer.CHECKOUT_CARD, response: response)
        }
        .background(.white)
    }
    public func onFinish(_ otp: String, next: String) {
        showPinDialog = false
        checkoutVm.showView = false
        listener.onAddNewCardClick()
    }
    fileprivate func setCheckoutTitle() {
        title = checkoutVm.currentService.isAirtimeService ? "Buy Airtime" : "Pay \(checkoutVm.currentService.serviceName)"
    }
    fileprivate func setPaymentServiceProviderModelFromServices(_ services: [MerchantPayer]) {
        checkoutVm.slm.selectedProvider = services.first?.clientName ?? ""
        checkoutVm.slm.serviceModels = services.map {
            ServiceModel(name: $0.clientName, logoUrl: $0.logo ?? "", canOthersPay: $0.canPayForOther == "1" ? true : false )
        }
    }
    fileprivate func handleKeyboardDone() -> ToolbarItemGroup<TupleView<(Spacer, Button<Text>?, Button<Text>?, Button<Text>?)>> {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            if focused == checkoutVm.selectedAmount {
                Button("Done") {
                    focused = nil
                }
            }
            if (focused == checkoutVm.selectedAmount) && someoneElseIsPaying {
                Button("Next") {
                    focused = checkoutVm.currentAccountNumber
                }
            }
            if someoneElseIsPaying && (focused == checkoutVm.currentAccountNumber) {
                Button("Done") {
                    focused = nil
                }
            }
         }
        
    }
    fileprivate func updateButtonLabel() {
        withAnimation {
            buttonText = "Pay \(checkoutVm.selectedAmount)"
        }
    }
    @ViewBuilder
    fileprivate func CardDropDownView() -> some View {
        Group {
            DebitCardDropDownView(dcddm: $checkoutVm.dcddm)
                .showIf($checkoutVm.showCardOptions)
                .showIf(.constant(checkoutVm.dcddm.cardDetails.isNotEmpty()))
            AddNewDebitOrCreditCardButton() {
                checkoutVm.cardDetails.amount = checkoutVm.amount
                showPinDialog = true
            }
            .showIf($checkoutVm.addNewCard)
        }.showIfNot($showingDropDown)
    }
    @ViewBuilder
    fileprivate func PaymentDetailView() -> some View {
        MerchantPayerListView(
            slm: $checkoutVm.slm
        ) {
            //TODO
        }
    }
    @ViewBuilder
    fileprivate func HorizontalLogoAndServiceName() -> some View {
        HStack {
            Text(title)
                .frame(alignment: .center)
                .bold()
                .foregroundColor(.black)
            Spacer()
            IconImageCardView(
                imageUrl: checkoutVm.currentService.serviceLogo,
                radius: 50
            ).scaleEffect(0.7)
        }
    }
    fileprivate func onButtonClick() {
        isValidPhoneNumber = validateWithRegex(checkoutVm.countryMobileRegex, value: checkoutVm.currentAccountNumber)
        if !isValidPhoneNumber {
            checkoutVm.uiModel = UIModel.error("Invalid phone number")
            return
        }
        if !isValidAmount {
            let min = checkoutVm.currentService.minAmount
            let max = checkoutVm.currentService.maxAmount
            checkoutVm.uiModel = UIModel.error("Amount must be between \(min) and \(max)")
            return
        }
        if checkoutVm.isSomeoneElsePaying {
            if !isValidSomeoneElsePhoneNumber {
                checkoutVm.uiModel = UIModel.error("Invalid phone number")
                return
            }
        }
        switch checkoutVm.currentPaymentProvider.checkoutType {
        case MerchantPayer.CHECKOUT_USSD_PUSH:
            raiseInvoice()
        case MerchantPayer.CHECKOUT_IN_APP:
            fetchCustomerDtbAccounts()
        case MerchantPayer.CHECKOUT_CARD:
            showPinView = true
        default:
            print("Default")
        }
    }
   private func createListOfCards(imageUrl:String) -> [CardDetailDTO] {
        return Observer<Card>().getEntities().map { c in
             CardDetailDTO(cardAlias: c.cardAlias ?? "", payerClientID: c.payerClientID ?? "", cardType: c.cardType ?? "", activeStatus: c.activeStatus ?? "", logoUrl: imageUrl)
        }
    }
   private func getAvailableInvoice() -> Invoice {
       return Observer<Invoice>().getEntities().first(where: { invoice in
            checkoutVm.enrollments.first { e in
                e.clientProfileAccountID == invoice.enrollment?.clientProfileAccountID
            }?.accountNumber == checkoutVm.currentAccountNumber
       }) ?? .init()
    }
    private func raiseInvoice() {
        let _ = Observer<ManualBill>().getEntities()
        
        let currentCurrency = checkoutVm.currency
        let currentAccountNumber = checkoutVm.currentAccountNumber
        let currentAmount = checkoutVm.selectedAmount
        let profileId = profile?.profileID ?? ""
        let alias = profile?.accountAlias ?? "customer"
    
        let builder = RequestMap.Builder()
            .add(value: "RINV", for: .SERVICE)
            .add(value: getPayingMSISDN(), for: .MSISDN)
            .add(value: checkoutVm.isSomeoneElsePaying, for: "IS_THIRD_PARTY_PAYMENT")
            .add(value: checkoutVm.myPhoneNumber, for: "ORIGINATOR_MSISDN")
            .add(value: currentAmount, for: .AMOUNT)
            .add(value: checkoutVm.currentService.hubServiceID, for: .SERVICE_ID)
            .add(value: currentAccountNumber, for: .ACCOUNT_NUMBER)
            .add(value: getAvailableInvoice().invoiceNumber, for: "INVOICE_NUMBER")
            .add(value: "", for: "BILL_AMOUNT")
            .add(value: currentCurrency, for: "CURRENCY")
            .add(value: "", for: "REWARD")
            .add(value: "ADD", for: .ACTION)
            .add(value: getAvailableInvoice().dueDate, for: "DUE_DATE")
            .add(value: "", for: "NARRATION")
            .add(value: getAvailableInvoice().estimateExpiryDate, for: "EXPIRY_DATE")
            .add(value: "", for: "PAYER_TRANSACTION_ID")
            .add(value: checkoutVm.service.serviceName, for: "SERVICE_NAME")
            .add(value: checkoutVm.currentService.serviceCode, for: "SERVICE_CODE")
            .add(value: checkoutVm.currentPaymentProvider.hubClientID, for: "PAYER_CLIENT_ID")
            .add(value: "", for: "PRODUCT_CODE")
            .add(value: "", for: "BEEP_TRANSACTION_ID")
            .add(value: "", for: "WALLET_DATA")
            .add(value: checkoutVm.currentService.hubClientID, for: "HUB_CLIENT_ID")
            .add(value: "", for: "PAYBILL")
            .add(value: getAvailableInvoice().callbackData, for: "CALLBACK_DATA")
            .add(value: getAvailableInvoice().billReference, for: "REFERENCE_NUMBER")
            .add(value: "1", for: "NOMINATE")
            .add(value: profileId, for: "PROFILE_ID")
            .add(value: encryptePIN, for: "PIN")
            .add(value: checkoutVm.currentPaymentProvider.checkoutType, for: "CHECKOUT_TYPE")
            .add(value: "", for: "ACCOUNT_ID")
            .add(value: alias, for: "ACCOUNT_ALIAS")
            .add(value: "1", for: "IS_APP_INVOICE")
            .add(value: "0", for: "CHECK_MODE")
            .add(value: "", for: "MERCHANT_TIER_CODE")
            .add(value: "", for: "BUNDLE_ID")
            .add(value: "", for: "PIN_CODE")
            .add(value: "", for: "MULA_PIN")
            .add(value: "", for: "EXTRA_DATA")
        
        if checkoutVm.currentService.isABundleService {
           _ = builder.add(value: checkoutVm.bundleModel.selectedBundleObject.bundleID, for: "BUNDLE_ID")
           
        }
        let request = builder.build()
        
        checkoutVm.raiseInvoiceRequest(request: request)
    }
    private func getPayingMSISDN() -> String {
        checkoutVm.isSomeoneElsePaying = someoneElseIsPaying
        return checkoutVm.isSomeoneElsePaying ? checkoutVm.phoneNumber : AppStorageManager.getPhoneNumber()
        
    }
    
    private func fetchCustomerDtbAccounts() {
        let request = RequestMap.Builder()
            .add(value: selectedPayer.hubClientID, for: "PAYER_CLIENT_ID")
            .add(value: "FWC", for: .SERVICE)
            .build()
        checkoutVm.makeFWCRequest(request: request)
    }
    public func onFinishInput(_ otp: String) {
        let pin  = AppStorageManager.mulaPin
        let request = RequestMap.Builder()
            .add(value: "VALIDATE", for: .ACTION)
            .add(value: "MPM", for: .SERVICE)
            .add(value: pin, for: "MULA_PIN")
            .build()
        checkoutVm.validatePin(request: request)
    }
    private func makeCardCheckoutRequest() {
        let request = RequestMap.Builder()
            .add(value: "CREATE_CHANNEL_REQUEST", for: .ACTION)
            .add(value: "ECP", for: .SERVICE)
            .add(value: "0", for: "PAYER_CLIENT_ID")
            .add(value: checkoutVm.currentService.serviceName, for: "SERVICE_NAME")
            .add(value: checkoutVm.currentService.serviceCode, for: "SERVICE_CODE")
            .add(value: checkoutVm.currentService.hubServiceID, for: .SERVICE_ID)
            .add(value: checkoutVm.currentAccountNumber, for: .ACCOUNT_NUMBER)
            .add(value: checkoutVm.selectedAmount, for: .AMOUNT)
            .add(value: "001", for: "card_type")
            .add(value: checkoutVm.currency, for: "currency")
            .add(value: getAvailableInvoice().invoiceNumber, for: "INVOICE_NUMBER")
            .add(value: "0", for: "CHECK_MODE")
            .add(value: CreditCardUtil.encrypt(data: pin), for: "MULA_PIN")
            .add(value: CreditCardUtil.encrypt(data: checkoutVm.cardDetails.suffix), for: "CARD_ALIAS")
            .add(value: "", for: "BUNDLE_ID")
            .build()
        checkoutVm.createCreditCardChannel(tinggRequest: request)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    struct CheckoutPreviewHolder: View, CheckoutListener {
        func onAddNewCardClick() {
            //
        }
        
        func onCheckoutSuccess(checkoutType: String, response: BaseDTOprotocol) {
            //
        }
        
        func onAddNewBillClick() {
            //
        }
        
        func navigateToInvoicePage() {
            //
        }
        
        var body: some View {
            CheckoutView(listener: self)
                .environmentObject(CheckoutDI.createCheckoutViewModel())
                .environmentObject(ContactViewModel())
                .environmentObject(NavigationManager())
        }
    }
    static var previews: some View {
        CheckoutPreviewHolder()
    }
}



public protocol CheckoutListener {
    func onCheckoutSuccess(checkoutType: String, response: BaseDTOprotocol)
    func navigateToInvoicePage()
    func onAddNewBillClick()
    func onAddNewCardClick()
}
