//
//  SwiftUIView.swift
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


public struct CheckoutView: View, OnPINCompleteListener {
    
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
    @State private var showAlertForRINV = false
    @State private var showAlertForFWC = false
    @State private var currency = ""
    @State private var selectedService: MerchantService = sampleServices[0]
    let profile = Observer<Profile>().getEntities().first
    @FocusState var focused: String?
    public init () {
      //
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center) {
                Section {
                    HorizontalLogoAndServiceName()
                    
                    DropDownView(selectedText: $selectedAccount, dropDownList: $accountList, showDropDown: $showingDropDown
                    ).showIf($isQuickTopUpOrAirtime)
                    
                    PaymentDetailView()
                }.padding(.horizontal)
                Section {
                    Toggle(
                        "Ask someone else to pay",
                        isOn:  $someoneElseIsPaying
                    )
                    .toggleStyle(
                        SwitchToggleStyle(
                            tint: PrimaryTheme.getColor(.primaryColor)
                        )
                    )
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                    )
                    .foregroundColor(.black)
                    TextFieldAndRightIcon(
                        number: $checkoutVm.fem.accountNumber
                    ) {
                        fetchContacts()
                    }
                    .disabled(
                        checkoutVm.isSomeoneElsePaying ? false : true
                    )
                    .showIf($someoneElseIsPaying)
                    .focused(
                        $focused, equals: checkoutVm.fem.accountNumber
                    )
                }
                .padding(.horizontal)
                .showIf($checkoutVm.isSomeoneElsePaying)
                .showIfNot($showingDropDown)
                
                CardDropDownView()
                
                Spacer()
                
                //MARK: Button
                TinggButton(
                    backgroundColor: PrimaryTheme.getColor(.primaryColor),
                    buttonLabel: buttonText
                ) {
                    onButtonClick()
                }.padding()
                .showIfNot($showingDropDown)
                .focused($focused, equals: nil)
            }
            .sheet(isPresented: $contactViewModel.showContact) {
                showContactView(contactViewModel: contactViewModel)
            }
        
            .toolbar {
                handleKeyboardDone()
            }
            .onAppear {
                selectedService = checkoutVm.slm.selectedService
                log(message: "\(selectedService)")
                buttonText = "Pay \(checkoutVm.sam.amount)"
                currency = (AppStorageManager.getCountry()?.currency) ?? ""
                checkoutVm.slm.payers = Observer<MerchantPayer>().getEntities()
                    .filter{$0.activeStatus != "0"}
                questions = Observer<SecurityQuestion>().getEntities().map {$0.question}
                checkoutVm.cardDetails.amount = checkoutVm.sam.amount
                accountList = checkoutVm.fem.enrollments.compactMap {$0.accountNumber}
                isQuickTopUpOrAirtime = selectedService.isAirtimeService
                updateButtonLabel()
                
            }
            .onChange(of: checkoutVm.slm) { model in
                someoneElseIsPaying = false
                checkoutVm.isSomeoneElsePaying = model.selectedPayer.canPayForOther == "0" ? false : true
               
                if model.selectedPayer.checkoutType == MerchantPayer.CHECKOUT_CARD {
                    let listOfCards = createListOfCards(imageUrl: model.selectedPayer.logo ?? "")
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
                let payer = model.payers.first { p in
                    p.clientName == model.selectedProvider
                }
                if let p = payer {
                    checkoutVm.slm.selectedPayer = p
                }
            }
            .onChange(of: contactViewModel.selectedContact) { newValue in
                checkoutVm.fem.accountNumber = newValue
            }
            .onChange(of: selectedAccount, perform: { newValue in
                checkoutVm.fem.accountNumber = newValue
            })
            .onChange(of: checkoutVm.sam.amount, perform: { newValue in
                buttonText = "Pay \(newValue)"
            })
            .customDialog(isPresented: $showDTBPINDialog) {
                DTBCheckoutDialogView(imageUrl: selectedPayer.logo!, dtbAccounts: dtbAccounts) {
                    pin in
                    encryptePIN = pin
                    raiseInvoice()
                }
            }
            .customDialog(isPresented: $showPinView, cancelOnTouchOutside: .constant(true), dialogContent: {
                VStack {
                    OtpFieldView(fieldSize: 4, otpValue: $pin, focusColor: PrimaryTheme.getColor(.primaryColor), toHaveBorder: true, onCompleteListener: self)
                    Text("Forgot PIN?")
                        .font(.caption)
                        .padding(.vertical)
                }.padding(40)
                .handleViewStatesMods(uiState: checkoutVm.$validatePinUImodel) { content in
                    log(message: content)
                    let response = content.data as! BaseDTO
                    log(message: "\(response)")
                    showAlertForPin = true
                    showPinView = false
                } action: {
                    makeCardCheckoutRequest()
                }
            })
            .handleViewStatesMods(uiState: checkoutVm.$raiseInvoiceUIModel) { content in
                let response = content.data as! RINVResponse
                log(message: "\(response)")
               
            } action: {
                let alias = profile?.accountAlias ?? "NA"
                let currentAccountNumber = selectedAccount.isEmpty ? checkoutVm.fem.accountNumber : selectedAccount
                let transaction = TransactionItemModel(
                    imageurl: checkoutVm.slm.selectedService.serviceLogo,
                    accountName: alias,
                    accountNumber: currentAccountNumber,
                    date: Date.now,
                    amount: Double(checkoutVm.sam.amount) ?? 0.0,
                    payer: checkoutVm.slm.selectedPayer,
                    service: checkoutVm.slm.selectedService,
                    status: .pending
                )
                navigation.navigationStack.append(Screens.transactionListView(transaction))
//                navigation.navigationStack.append(Screens.home)
            }
            .handleViewStatesMods(uiState: checkoutVm.$fwcUIModel) { content in
                log(message: content)
                let response = content.data as! DTBAccountsResponse
                dtbAccounts = response.accounts ?? []
                showDTBPINDialog = true
            }
            .handleViewStatesMods(uiState: checkoutVm.$uiModel) { content in
                log(message: content)
                let response = content.data as! CreateCardChannelResponse
                checkoutVm.cardDetails.checkout = true
                navigation.navigationStack.append(Screens.cardDetailsView(response, nil))
            }
        }.background(.white)
       
    }
    fileprivate func handleKeyboardDone() -> ToolbarItemGroup<TupleView<(Spacer, Button<Text>?, Button<Text>?, Button<Text>?)>> {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            if focused == checkoutVm.sam.amount {
                Button("Done") {
                    focused = nil
                }
            }
            if (focused == checkoutVm.sam.amount) && someoneElseIsPaying {
                Button("Next") {
                    focused = checkoutVm.fem.accountNumber
                }
            }
            if someoneElseIsPaying && (focused == checkoutVm.fem.accountNumber) {
                Button("Done") {
                    focused = nil
                }
            }
         }
        
    }
    fileprivate func updateButtonLabel() {
        withAnimation {
            buttonText = "Pay \(checkoutVm.sam.amount)"
        }
    }
    fileprivate func fetchContacts() {
        Task {
            await contactViewModel.fetchPhoneContacts { err in
                checkoutVm.uiModel = UIModel.error(err.localizedDescription)
            }
        }
    }
    @ViewBuilder
    fileprivate func CardDropDownView() -> some View {
        Group {
            DebitCardDropDownView(dcddm: $checkoutVm.dcddm)
                .padding()
                .showIf($checkoutVm.showCardOptions)
                .showIf(.constant(checkoutVm.dcddm.cardDetails.isNotEmpty()))
            AddNewDebitOrCreditCardButton() {
                dismiss()
                checkoutVm.cardDetails.amount = checkoutVm.amount
                navigation.navigationStack.append(Screens.pinCreationView)
            }
            .showIf($checkoutVm.addNewCard)
            .padding(30)
        }.showIfNot($showingDropDown)
    }
    @ViewBuilder
    fileprivate func PaymentDetailView() -> some View {
        Group {
            TextFieldView(fieldText: $checkoutVm.sam.amount, label: "", placeHolder: "Enter amount")
                .foregroundColor(.black)
                .disabled(selectedService.canEditAmount == "0" ? false : true)
                .onChange(of: checkoutVm.sam.amount) { newValue in
                    checkoutVm.sam.amount = newValue.applyPattern(pattern: "\(checkoutVm.sam.currency) ##")
                }
                .focused($focused, equals: checkoutVm.sam.amount)
            MerchantPayerListView(
                slm: $checkoutVm.slm
            ) {
                //TODO
            }
        }.showIfNot($showingDropDown)
    }
    @ViewBuilder
    fileprivate func HorizontalLogoAndServiceName() -> some View {
        HStack {
            Text(title)
                .frame(alignment: .center)
                .padding(.vertical)
                .bold()
                .foregroundColor(.black)
            Spacer()
            IconImageCardView(
                imageUrl: checkoutVm.slm.selectedService.serviceLogo,
                radius: 50,
                scaleEffect: 0.7
            ).scaleEffect(0.7)
        }
    }
    fileprivate func onButtonClick() {
        let isValidated: Bool = validatePhoneNumberByCountry(AppStorageManager.getCountry(), phoneNumber: checkoutVm.fem.accountNumber)
        log(message: "\(checkoutVm.fem)")
        if !isValidated {
            checkoutVm.uiModel = UIModel.error("Invalid phone number")
            return
        }
        
        let currentCurrency = checkoutVm.sam.currency
        let currentAmount = checkoutVm.sam.amount.replace(string: currentCurrency, replacement: "")
        let isValidAmount = validateAmountByService(selectedService: checkoutVm.slm.selectedService, amount: currentAmount)
        if !isValidAmount.isEmpty {
            showAlert = true
            checkoutVm.uiModel = UIModel.error(isValidAmount)
            return
        }
        checkoutVm.isSomeoneElsePaying = someoneElseIsPaying
        
        switch checkoutVm.slm.selectedPayer.checkoutType {
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
            checkoutVm.fem.enrollments.first { e in
                e.clientProfileAccountID == invoice.enrollment?.clientProfileAccountID
            }?.accountNumber == checkoutVm.fem.accountNumber
       }) ?? .init()
    }
    private func raiseInvoice() {
        let _ = Observer<ManualBill>().getEntities()
        
        let country = AppStorageManager.getCountry() ?? .init()
        let currentCurrency = country.currency ?? ""
        let currentAccountNumber = selectedAccount.isEmpty ? checkoutVm.fem.accountNumber : selectedAccount
        let currentAmount = checkoutVm.sam.amount
        let profileId = profile?.profileID ?? ""
        let alias = profile?.accountAlias ?? ""
    
        let request = RequestMap.Builder()
            .add(value: "RINV", for: .SERVICE)
            .add(value: getPayingMSISDN(), for: .MSISDN)
            .add(value: checkoutVm.isSomeoneElsePaying, for: "IS_THIRD_PARTY_PAYMENT")
            .add(value: AppStorageManager.getPhoneNumber(), for: "ORIGINATOR_MSISDN")
            .add(value: currentAmount, for: .AMOUNT)
            .add(value: checkoutVm.slm.selectedService.hubServiceID, for: .SERVICE_ID)
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
            .add(value: checkoutVm.service.serviceCode, for: "SERVICE_CODE")
            .add(value: checkoutVm.slm.selectedPayer.hubClientID, for: "PAYER_CLIENT_ID")
            .add(value: "", for: "PRODUCT_CODE")
            .add(value: "", for: "BEEP_TRANSACTION_ID")
            .add(value: "", for: "WALLET_DATA")
            .add(value: checkoutVm.slm.selectedService.hubClientID, for: "HUB_CLIENT_ID")
            .add(value: "", for: "PAYBILL")
            .add(value: getAvailableInvoice().callbackData, for: "CALLBACK_DATA")
            .add(value: getAvailableInvoice().billReference, for: "REFERENCE_NUMBER")
            .add(value: "1", for: "NOMINATE")
            .add(value: profileId, for: "PROFILE_ID")
            .add(value: encryptePIN, for: "PIN")
            .add(value: checkoutVm.slm.selectedPayer.checkoutType, for: "CHECKOUT_TYPE")
            .add(value: "", for: "ACCOUNT_ID")
            .add(value: alias, for: "ACCOUNT_ALIAS")
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
        checkoutVm.isSomeoneElsePaying = someoneElseIsPaying
        return checkoutVm.isSomeoneElsePaying ? checkoutVm.fem.accountNumber : AppStorageManager.getPhoneNumber()
        
    }
    
    private func fetchCustomerDtbAccounts() {
        let request = RequestMap.Builder()
            .add(value: selectedPayer.hubClientID, for: "PAYER_CLIENT_ID")
            .add(value: "FWC", for: .SERVICE)
            .build()
        checkoutVm.makeFWCRequest(request: request)
    }
    public func submit() {
        let request = RequestMap.Builder()
            .add(value: "VALIDATE", for: .ACTION)
            .add(value: "MPM", for: .SERVICE)
            .add(value: CreditCardUtil.encrypt(data: pin), for: "MULA_PIN")
            .build()
        checkoutVm.validatePin(request: request)
    }
    private func makeCardCheckoutRequest() {
        let country = AppStorageManager.getCountry()
        let request = RequestMap.Builder()
            .add(value: "CREATE_CHANNEL_REQUEST", for: .ACTION)
            .add(value: "ECP", for: .SERVICE)
            .add(value: "0", for: "PAYER_CLIENT_ID")
            .add(value: checkoutVm.service.serviceName, for: "SERVICE_NAME")
            .add(value: checkoutVm.service.serviceCode, for: "SERVICE_CODE")
            .add(value: checkoutVm.service.hubServiceID, for: .SERVICE_ID)
            .add(value: checkoutVm.fem.accountNumber, for: .ACCOUNT_NUMBER)
            .add(value: checkoutVm.sam.amount, for: .AMOUNT)
            .add(value: "001", for: "card_type")
            .add(value: country?.currency, for: "currency")
            .add(value: getAvailableInvoice().invoiceNumber, for: "INVOICE_NUMBER")
            .add(value: "0", for: "CHECK_MODE")
            .add(value: CreditCardUtil.encrypt(data: pin), for: "MULA_PIN")
            .add(value: CreditCardUtil.encrypt(data: checkoutVm.cardDetails.suffix), for: "CARD_ALIAS")
            .add(value: "", for: "BUNDLE_ID")
            .build()
        checkoutVm.createCreditCardChannel(tinggRequest: request)
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
