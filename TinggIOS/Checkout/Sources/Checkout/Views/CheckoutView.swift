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
    @State private var selectedService: MerchantService = .init()
    @FocusState var focused: String?
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
                        imageUrl: checkoutVm.slm.selectedService.serviceLogo,
                        radius: 50,
                        scaleEffect: 0.7
                    )
                }
                DropDownView(selectedText: $selectedAccount, dropDownList: $accountList, showDropDown: $showingDropDown
                ).showIf($isQuickTopUpOrAirtime)
                Group {
                    TextFieldView(fieldText: $checkoutVm.sam.amount, label: "", placeHolder: "Enter amount")
                        .disabled(selectedService.canEditAmount == "0" ? false : true)
                        .onChange(of: checkoutVm.sam.amount) { newValue in
                            checkoutVm.sam.amount = newValue.applyPattern(pattern: "\(checkoutVm.sam.currency) ##")
                        }
                        .focused($focused, equals: checkoutVm.sam.amount)
                    MerchantPayerListView(
                        slm: $checkoutVm.slm
                    ) {  }
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
                    number: $checkoutVm.fem.accountNumber
                ) {
                    Task {
                        await contactViewModel.fetchPhoneContacts { err in
                            checkoutVm.uiModel = UIModel.error(err.localizedDescription)
                        }
                    }
                }.disabled(checkoutVm.isSomeoneElsePaying ? false : true)
                .showIf($someoneElseIsPaying)
                .focused($focused, equals: checkoutVm.fem.accountNumber)
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
                    checkoutVm.cardDetails.amount = checkoutVm.amount
                    navigation.navigationStack.append(Screens.pinCreationView)
                }
                .showIf($checkoutVm.addNewCard)
                .padding(30)
            }.showIfNot($showingDropDown)
            Spacer()
            
            //MARK: Button
            TinggButton(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: buttonText
            ) {
                onButtonClick()
            }.padding()
        }
        .sheet(isPresented: $contactViewModel.showContact) {
            showContactView(contactViewModel: contactViewModel)
        }
        .toolbar {
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

        .onAppear {
            withAnimation {
                selectedService = checkoutVm.slm.selectedService
                log(message: "\(selectedService)")
                buttonText = "Pay \(checkoutVm.sam.amount)"
                currency = (AppStorageManager.getCountry()?.currency)!
                checkoutVm.slm.payers = Observer<MerchantPayer>().getEntities()
                    .filter{$0.activeStatus != "0"}
                questions = Observer<SecurityQuestion>().getEntities().map {$0.question}
                checkoutVm.cardDetails.amount = checkoutVm.sam.amount
                accountList = checkoutVm.fem.enrollments.compactMap {$0.accountNumber}
                isQuickTopUpOrAirtime = selectedService.isAirtimeService
            
                
                //MARK: Observe create checkout channel
                checkoutVm.observeUIModel(model: checkoutVm.$uiModel, subscriptions: &checkoutVm.subscriptions) { content in
                    let response = content.data as! CreateCardChannelResponse
                    checkoutVm.cardDetails.checkout = true
                    navigation.navigationStack.append(Screens.cardDetailsView(response, nil))
                    log(message: "\(response)")
                } onError: { err in
                    showAlert = true
                    log(message: err)
                }
                if checkoutVm.slm.selectedService.isAirtimeService {
                    buttonText = "Buy \(checkoutVm.service.serviceName)"
                } else {
                    buttonText = "Pay \(checkoutVm.sam.amount)"
                }
            }
            
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
            if checkoutVm.slm.selectedService.isAirtimeService {
                buttonText = "Buy \(checkoutVm.service.serviceName)"
            } else {
                buttonText = "Pay \(newValue)"
            }
        })
        .customDialog(isPresented: $showDTBPINDialog) {
            DTBCheckoutDialogView(imageUrl: selectedPayer.logo!, dtbAccounts: dtbAccounts) {
                pin in
                PayerChargeCalculator.checkCharges(merchantPayer: selectedPayer, merchantService: checkoutVm.service, amount: Double(checkoutVm.sam.amount) ?? 0.0)
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
            .onAppear {
                //MARK: Observe Pin validation Request
                checkoutVm.observeUIModel(model: checkoutVm.$validatePinUImodel, subscriptions: &checkoutVm.subscriptions) { content in
                    let response = content.data as! BaseDTO
                    log(message: "\(response)")
                    showAlertForPin = true
                    showPinView = false
                } onError: { err in
                    showAlertForPin = true
                    log(message: err)
                }
            }
            .handleViewStates(uiModel: $checkoutVm.validatePinUImodel, showAlert: $showAlertForPin, showSuccessAlert: $showAlertForPin, onSuccessAction: makeCardCheckoutRequest)
        })
        .handleViewStates(uiModel: $checkoutVm.raiseInvoiceUIModel, showAlert:  $showAlertForRINV, showSuccessAlert: $showAlertForRINV)
        .handleViewStates(uiModel: $checkoutVm.fwcUIModel, showAlert:  $showAlertForFWC)
        .handleViewStates(uiModel: $checkoutVm.uiModel, showAlert:  $showAlert)
       
    }
    fileprivate func onButtonClick() {
        let isValidated: Bool = validatePhoneNumberByCountry(AppStorageManager.getCountry(), phoneNumber: checkoutVm.fem.accountNumber)
        log(message: "\(checkoutVm.fem)")
        if !isValidated {
            checkoutVm.uiModel = UIModel.error("Invalid phone number")
            return
        }
        
        let currency = checkoutVm.sam.currency
        let amount = checkoutVm.sam.amount.replace(string: currency, replacement: "")
        let isValidAmount = validateAmountByService(selectedService: checkoutVm.slm.selectedService, amount: amount)
        if !isValidAmount.isEmpty {
            showAlert = true
            checkoutVm.uiModel = UIModel.error(isValidAmount)
            return
        }
        checkoutVm.isSomeoneElsePaying = someoneElseIsPaying
        
        switch checkoutVm.slm.selectedPayer.checkoutType {
        case MerchantPayer.CHECKOUT_USSD_PUSH:
            raiseInvoice()
            //MARK: Observe RINV Request
            checkoutVm.observeUIModel(model: checkoutVm.$raiseInvoiceUIModel, subscriptions: &checkoutVm.subscriptions) { content in
                let response = content.data as! RINVResponse
                showAlertForRINV = true
                log(message: "\(response)")
            } onError: { err in
                showAlertForRINV = true
                log(message: err)
            }
        case MerchantPayer.CHECKOUT_IN_APP:
            fetchCustomerDtbAccounts()
            //MARK: Observe FWC request
            checkoutVm.observeUIModel(model: checkoutVm.$fwcUIModel, subscriptions: &checkoutVm.subscriptions) { content in
                let response = content.data as! DTBAccountsResponse
                dtbAccounts = response.accounts ?? []
                showDTBPINDialog = true
            } onError: { err in
                showAlertForFWC = true
                log(message: err)
            }
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
   private func getAvailableInvoice() -> Invoice? {
       return Observer<Invoice>().getEntities().first(where: { invoice in
            checkoutVm.fem.enrollments.first { e in
                e.clientProfileAccountID == invoice.enrollment?.clientProfileAccountID
            }?.accountNumber == checkoutVm.fem.accountNumber
        })
    }
    private func raiseInvoice() {
        let _ = Observer<ManualBill>().getEntities()
        let profile = Observer<Profile>().getEntities().first
        let accountNumber = selectedAccount.isEmpty ? checkoutVm.fem.accountNumber : selectedAccount
        let currency = checkoutVm.sam.currency
        let amount = checkoutVm.sam.amount.replace(string: currency, replacement: "")
        let request = RequestMap.Builder()
            .add(value: "RINV", for: .SERVICE)
            .add(value: getPayingMSISDN(), for: .MSISDN)
            .add(value: checkoutVm.isSomeoneElsePaying, for: "IS_THIRD_PARTY_PAYMENT")
            .add(value: AppStorageManager.getPhoneNumber(), for: "ORIGINATOR_MSISDN")
            .add(value: amount, for: .AMOUNT)
            .add(value: checkoutVm.slm.selectedService.hubServiceID, for: .SERVICE_ID)
            .add(value: accountNumber, for: .ACCOUNT_NUMBER)
            .add(value: getAvailableInvoice()?.invoiceNumber, for: "INVOICE_NUMBER")
            .add(value: amount, for: "BILL_AMOUNT")
            .add(value: AppStorageManager.getCountry()?.currency, for: "CURRENCY")
            .add(value: "", for: "REWARD")
            .add(value: "ADD", for: .ACTION)
            .add(value: getAvailableInvoice()?.dueDate, for: "DUE_DATE")
            .add(value: "", for: "NARRATION")
            .add(value: getAvailableInvoice()?.estimateExpiryDate, for: "EXPIRY_DATE")
            .add(value: "", for: "PAYER_TRANSACTION_ID")
            .add(value: checkoutVm.service.serviceName, for: "SERVICE_NAME")
            .add(value: checkoutVm.service.serviceCode, for: "SERVICE_CODE")
            .add(value: checkoutVm.slm.selectedPayer.hubClientID, for: "PAYER_CLIENT_ID")
            .add(value: "", for: "PRODUCT_CODE")
            .add(value: "", for: "BEEP_TRANSACTION_ID")
            .add(value: "", for: "WALLET_DATA")
            .add(value: checkoutVm.slm.selectedService.hubClientID, for: "HUB_CLIENT_ID")
            .add(value: "", for: "PAYBILL")
            .add(value: getAvailableInvoice()?.callbackData, for: "CALLBACK_DATA")
            .add(value: getAvailableInvoice()?.billReference, for: "REFERENCE_NUMBER")
            .add(value: "1", for: "NOMINATE")
            .add(value: profile?.profileID, for: "PROFILE_ID")
            .add(value: encryptePIN, for: "PIN")
            .add(value: checkoutVm.slm.selectedPayer.checkoutType, for: "CHECKOUT_TYPE")
            .add(value: "", for: "ACCOUNT_ID")
            .add(value: profile?.accountAlias, for: "ACCOUNT_ALIAS")
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
            .add(value: getAvailableInvoice()?.invoiceNumber, for: "INVOICE_NUMBER")
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


