//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 12/01/2023.
//
import Core
import CoreUI
import Permissions
import SwiftUI
import Theme
public struct EnterCardDetailsView: View {
    //MARK: Variables
    @EnvironmentObject var creditCardVm: CreditCardViewModel
    @EnvironmentObject var navigation: NavigationUtils
    @EnvironmentObject var contactVm: ContactViewModel
    @State private var isFilling = false
    @State private var cardNumberHolderText = "Card number"
    @State private var buttonBgColor: Color = .gray.opacity(0.5)
    @State private var editing = false
    @State private var counter = 20
    @State private var isMaxNumber = false
    @State private var hasReachedFour = false
    @State private var trimmedValue = ""
    @State private var cardIcon = "creditcard"
    @State private var cardImage: PrimaryTheme.Images = .cardTempIcon
    @State private var expDateIsValid = false
    @State private var cardIsValid = false
    @State private var isCVVLengthValid = false
    @State private var isHolderNameValid = false
    @State private var disableButton = true
    @State private var showAlert = false
    @State private var successUrl: String = ""
    @State private var showWebView = false
    @State private var request: RequestMap? = nil
    @State private var checkoutUrl = ""
    @State private var htmlString = ""
    @State private var urlRequest: URLRequest? = nil
    @State var successCallbackUrl = DEFAULT_SUCCESS_CALLBACK_URL
    @State var isCardActivated = false
    @State var createChannelResponse: CreateCardChannelResponse?
    var invoice: Invoice?
    @Binding var cardDetails: CardDetails
    public init(cardDetails: Binding<CardDetails>, createChannelResponse: CreateCardChannelResponse?=nil, invoice: Invoice? = nil ) {
        self._cardDetails = cardDetails
        self.createChannelResponse = createChannelResponse
        self.invoice = invoice
    }
    public var body: some View {
        ZStack {
            VStack {
                CardTemplateAnimationView(
                    cardNumber: $cardDetails.cardNumber,
                    holderName: $cardDetails.holderName,
                    expDate: $cardDetails.expDate,
                    cvv: $cardDetails.cvv,
                    cardImage: $cardImage
                )
                HStack {
                    Image(systemName: "lock.fill")
                    Text("Card details are saved securely")
                }
                VStack {
                    TextFieldAndRightIcon(number: $cardDetails.cardNumber, iconName: cardIcon, placeHolder: cardNumberHolderText, success: $cardIsValid) {
                        print("")
                    }
                    HStack {
                        Spacer()
                        Text("\(cardDetails.cardNumber.replacingOccurrences(of: " ", with: "").count)/16")
                            .font(.caption)
                    }
                }
                VStack {
                    TextFieldView(fieldText: $cardDetails.holderName, label:"", placeHolder: "Card holder's name", success: $isHolderNameValid)
                    HStack {
                        TextFieldView(fieldText: $cardDetails.expDate, label:"", placeHolder: "Exp date",type: .numberPad,  success:  $expDateIsValid)
                        TextFieldView(fieldText: $cardDetails.cvv, label:"", placeHolder: "CVV", type: .numberPad, success:  $isCVVLengthValid)
                    }
                    HStack {
                        Spacer()
                        Text("\(cardDetails.cvv.count)/3")
                            .font(.caption)
                    }
                    TextFieldView(fieldText: $cardDetails.address, label:"", placeHolder: "Address")
                }
                Spacer()
                //Button
                TinggButton(backgroundColor: buttonBgColor, buttonLabel: "Continue", padding: 0) {
                    makeCreateCardChannelRequest()
                }.disabled(disableButton)
            }
            .padding()
            //WebView
            HTMLView(url: htmlString, webViewUIModel:creditCardVm.uiModel, didFinish: { url in
                log(message: url)
                handleWebViewFinishEvent(url: url)
            }, onTryAgain: {
               makeCreateCardChannelRequest()
            })
            .showIf($showWebView)
           
        }
        .onChange(of: cardDetails.cardNumber) { newValue in
            cardDetails.cardNumber = checkLength(newValue, length: 19)
            cardDetails.cardNumber = cardDetails.cardNumber.applyPattern()
            if cardDetails.cardNumber.starts(with: "5") {
                withAnimation(.linear(duration: 1.5)) {
                    cardImage = .mastercardIcon
                }
            } else if cardDetails.cardNumber.starts(with: "4") {
                withAnimation(.linear(duration: 1.5)) {
                    cardImage = .visa
                }
            } else {
               cardImage = .cardTempIcon
           }
            
            cardIsValid = cardCheck(number: newValue.replacingOccurrences(of: " ", with: ""))
            updateButton()
        }
        .onChange(of: cardDetails.expDate) { newValue in
            cardDetails.expDate = checkLength(cardDetails.expDate, length: 5)
            cardDetails.expDate = cardDetails.expDate.applyDatePattern()
            expDateIsValid = isExpiryDateValid(expDate: cardDetails.expDate)
            updateButton()
        }
        .onChange(of: cardDetails.cvv) { newValue in
            isCVVLengthValid = newValue.count < 3 ? false : true
            cardDetails.cvv = checkLength(newValue, length: 3)
            updateButton()
        }
        .onChange(of: cardDetails.holderName, perform: { newValue in
            isHolderNameValid = newValue.isEmpty ? false : true
            updateButton()
        })
        .onChange(of: cardDetails.address, perform: { newValue in
            updateButton()
        })
        .onAppear {
           
            updateButton()
            if cardDetails.checkout {
                let cvaKeyValueInRequest = createKeyValueAsRequest(createCardChannelResponse: createChannelResponse!)
                htmlString = createPostStringFromRequest(request: cvaKeyValueInRequest)
                showWebView = cardDetails.checkout
            }
            creditCardVm.observeUIModel(model: creditCardVm.$uiModel, subscriptions: &creditCardVm.subscriptions) { content in
                createChannelResponse = (content.data as! CreateCardChannelResponse)
                successUrl = createChannelResponse!.successUrl
                checkoutUrl = createChannelResponse!.webUrl.isEmpty ? EnterCardDetailsView.DEFAULT_CHECK_OUT_URL : createChannelResponse!.webUrl
                let cvaKeyValueInRequest = createKeyValueAsRequest(createCardChannelResponse: createChannelResponse!)
                htmlString = createPostStringFromRequest(request: cvaKeyValueInRequest)
                showWebView = !htmlString.isEmpty
            } onError: { err in
                showAlert = true
                print("Error String \(err)")
            }
        }
        .handleViewStates(uiModel: $creditCardVm.uiModel, showAlert: $showAlert)
        .navigationTitle("Card")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
            Button(action : {
                if showWebView {
                    successUrl = ""
                    showWebView.toggle()
                } else {
                   _ = navigation.navigationStack.popLast()
                }
            }){
                Text("Back")
            }
        )
    
    }
   
    func createPostStringFromRequest(request: RequestMap) -> String {
        var sb = ""
        sb.append("<!DOCTYPE html>")
        sb.append("<html><head>")
        sb.append("</head>")
        sb.append("<body onload='form1.submit()'>")
        sb.append("<form id='form1' action='\(checkoutUrl)' method='post'>")
        request.dict.forEach { (key: String, value: Any) in
            sb.append("<input type='hidden' name='\(key)' value='\(value)' />")
        }
        sb.append("</form></body></html>")
        print("SB \(sb)")
        return sb
    }
    
    func createCVARequest(request: Data, url: String) -> URLRequest? {
        do {
            var urlRequest = try URLRequest(url: url, method: .post)
            urlRequest.httpBody = request
            print("UrlRequest \(urlRequest)")
            return urlRequest
        } catch {
            print("createCVARequest \(error.localizedDescription)")
        }
        return nil
        
    }
    
    func createBodyStringFromRequest(req: RequestMap) -> String {
        var list = [String]()
        for (key, value) in req.dict {
            list.append(key+"=\(value)")
        }
        return list.map {String($0)}.joined(separator: "&")
    }
    
    private func createKeyValueAsRequest(createCardChannelResponse: CreateCardChannelResponse) -> RequestMap {
        getBaseRequestBuilderForPostCreateChannel(createCardChannelResponse: createCardChannelResponse)
            .add(value: "CARD_VALIDATION", for: "action")
            .build()
    }
    private func createECPKeyValueAsRequest(createCardChannelResponse: CreateCardChannelResponse) -> RequestMap {
        getBaseRequestBuilderForPostCreateChannel(createCardChannelResponse: createCardChannelResponse)
            .add(value: "CARD_PAYMENT", for: "action")
            .add(value: createCardChannelResponse.paymentToken, for: "paymentToken")
            .build()

    }
    func getBaseRequestBuilderForPostCreateChannel(createCardChannelResponse: CreateCardChannelResponse) -> RequestMap.Builder {
        guard let country = AppStorageManager.getCountry() else {
            fatalError("Unable to get country details")
        }
        let serviceDescription = "Payment of \( country.currency!) \(createCardChannelResponse.amount) for \(createCardChannelResponse.serviceName)  ."
        
        let profile = Observer<Profile>().getEntities()[0]
        var userName = ""
        
        if let firstName = profile.firstName, let lastName = profile.lastName {
            userName = firstName + " " + lastName
        } else {
            userName = "Customer"
        }
        
        
        let customerEmail = profile.emailAddress ?? "customer@cellulant.com"
        let webUrl = createCardChannelResponse.webUrl
        let statusUrl = createCardChannelResponse.successUrl + "?"
        
        guard let msisdn = Observer<Profile>().getEntities()[0].msisdn else {
            throwError(message: "Invalid MSISDN")
        }
        guard let countryCode = country.countryCode else {
            throwError(message: "Invalid Country code")
        }
        guard let currencyCode = country.currency else {
            throwError(message: "Invalid Currency code")
        }
        successCallbackUrl = statusUrl.isEmpty ? EnterCardDetailsView.DEFAULT_SUCCESS_CALLBACK_URL : statusUrl
        let encyrptedHolderName = CreditCardUtil.encrypt(data: cardDetails.holderName)
        let encryptedCVV = CreditCardUtil.encrypt(data: cardDetails.cvv)
        let cardNumberWithoutWhiteSpace = cardDetails.cardNumber.removeWhitespace()
        let encyrptedCardNumber =  CreditCardUtil.encrypt(data: cardNumberWithoutWhiteSpace)
        
        return RequestMap.Builder()
            .clear()
            .add(value: createCardChannelResponse.amount, for: "amount")
            .add(value: msisdn, for: "MSISDN")
            .add(value: uuidForVendor, for: "UUID")
            .add(value: currencyCode, for: "currencyCode")
            .add(value: serviceDescription, for: "serviceDescription")
            .add(value: countryCode, for: "countryCode")
            .add(value: customerEmail, for: "customerEmail")
            .add(value: userName, for: "customerFirstName")
            .add(value: cardDetails.encryptedExpDate, for: "expiry")
            .add(value: encyrptedHolderName, for: "cardName")
            .add(value: encryptedCVV, for: "cvn")
            .add(value: cardDetails.address, for: "postalAddress")
            .add(value: cardDetails.email, for: "emailAddress")
            .add(value: encyrptedCardNumber, for: "cardNumber")
            .add(value: createCardChannelResponse.serviceName, for: "serviceName")
            .add(value: "en", for: "language")
            .add(value: createCardChannelResponse.serviceCode, for: "serviceCode")
            .add(value: createCardChannelResponse.serviceId, for: "serviceId")
            .add(value: createCardChannelResponse.beepTransactionId, for: "reference")
            .add(value: webUrl, for: "webUrl")
            .add(value: createCardChannelResponse.beepTransactionId, for: "channelRequestID")
            .add(value: successCallbackUrl, for: "callBackUrl")
    }
    
    private func makeCreateCardChannelRequest() {
        if isHolderNameValid && expDateIsValid && isCVVLengthValid {
            cardDetails = cardDetails.encryptdata()
            let request = RequestMap.Builder()
                .add(value: "CREATE_CHANNEL_REQUEST", for: .ACTION)
                .add(value: "CVA", for: .SERVICE)
                .add(value: "0", for: "CHECK_MODE")
                .add(value: "", for: "EMAIL_ADDRESS")
                .add(value: cardDetails.address, for: "POSTAL_ADDRESS")
                .add(value: cardDetails.encryptedExpDate, for: "EX_DATE")
                .add(value: cardDetails.encryptedSuffix, for: .CARD_ALIAS)
                .add(value: creditCardVm.sam.amount, for: .AMOUNT)
                .build()

            Task {try await creditCardVm.createCreditCardChannel(tinggRequest: request)}
        } else {
            creditCardVm.uiModel = UIModel.error("Some details are missing")
        }
    }
    
    
    private func handleWebViewFinishEvent(url: String) {
        if url.contains(successUrl) || url.contains(EnterCardDetailsView.CARD_CHARGE_SUCCESS) {
             //intercept the GET params.
             //cuts to the parameters.
            let successPattern = #/SUCCESS=\w+/#
            if let successMatch = url.firstMatch(of: successPattern) {
                log(message: "\(successMatch)")
                let match = successMatch.output
                log(message: "\(String(describing: match))")
                let successValue = match.last!
                log(message: "\(String(describing: successValue))")
                let isSuccessful = successValue == "1" || successValue == "2"
                if isSuccessful {
                    isCardActivated = successValue == "2"
                    let card = Card()
                    card.cardAlias = ""
                    card.customerAddress = cardDetails.address
                    card.cardType = Card.TYPE_NORMAL
                    card.activeStatus = isCardActivated ? Card.STATUS_ACTIVE : Card.STATUS_INACTIVE
                    card.firstName = cardDetails.holderName.split(separator: " ").first?.description
                    card.middleName = cardDetails.holderName.split(separator: " ")[2].description
                    card.nameType = getCreditCardNameUsingCardNumber(creditCardNumber: cardDetails.cardNumber).rawValue
                    card.suffix = ""
                    card.validationServiceID = createChannelResponse?.serviceId
                    Observer<Card>().saveEntity(obj: card)
                }
                else if cardDetails.checkout && isSuccessful {
                    creditCardVm.uiModel = UIModel.loading
                    let _ = createChannelResponse
                    let raisedInvoice = self.invoice
                    if let amount = createChannelResponse?.amount {
                        raisedInvoice?.amount = String(amount)
                        raisedInvoice?.hasPaymentInProgress = true
                        let totalPaid = raisedInvoice!.partialPaidAmount + amount
                        switch true {
                        case totalPaid > amount:
                            raisedInvoice?.partialPaidAmount = 0.0
                            raisedInvoice?.fullyPaid = true
                            raisedInvoice?.overPaid = true
                        case totalPaid < amount:
                            raisedInvoice?.partialPaidAmount = totalPaid
                            raisedInvoice?.fullyPaid = false
                            raisedInvoice?.overPaid = false
                        case totalPaid == amount:
                            raisedInvoice?.partialPaidAmount = 0.0
                            raisedInvoice?.fullyPaid = true
                            raisedInvoice?.overPaid = false
                        default:
                            log(message: "Default")
                        }
                        Observer<Invoice>().saveEntity(obj: invoice!)
                        let userMSISDN = Observer<Profile>().getEntities()[0].msisdn
                        var customerName = ""
                        let accountNumber = creditCardVm.fem.accountNumber
                        if creditCardVm.service.isAirtimeService && ((userMSISDN?.elementsEqual(accountNumber)) != nil) {
                            customerName = "Me"
                        } else if creditCardVm.service.isAirtimeService {
                            Task {
                                await contactVm.fetchPhoneContactsWIthoutUI { cr in
                                    if cr.phoneNumber.elementsEqual(accountNumber) {
                                        customerName = cr.phoneNumber
                                    } else {
                                        customerName = ""
                                    }
                                } onError: { error in
                                    log(message: error.localizedDescription)
                                }
                            }

                        }
                        let payer = creditCardVm.slm.selectedPayer
                        let transactionHistory = TransactionHistory()
                        let beepTransactionId = (raisedInvoice?.beepTransactionID.isNotEmpty)! ? raisedInvoice?.beepTransactionID : createChannelResponse?.beepTransactionId
                        transactionHistory.beepTransactionID = beepTransactionId ?? ""
                        transactionHistory.amount = String(amount)
                        transactionHistory.billAmount = amount
                        transactionHistory.status = TransactionHistory.STATUS_EXPIRED
                        transactionHistory.transactionTitle = customerName
                        transactionHistory.currencyCode = AppStorageManager.getCountry()?.currency
                        transactionHistory.accountNumber = accountNumber
                        transactionHistory.serviceID = creditCardVm.service.hubServiceID
                        transactionHistory.msisdn = getPayingMSISDN()
                        transactionHistory.payerClientID = payer.hubClientID
                        transactionHistory.shortDescription = ">Transaction is in progress. Tingg Ref Number is \(raisedInvoice?.beepTransactionID ?? "")"
                        Observer<TransactionHistory>().saveEntity(obj: transactionHistory)
                        let content =  UIModel.Content(statusMessage: "Updated invoice")
                        creditCardVm.uiModel = UIModel.content(content)
                    }

                }
            }
        }
    }
    
    private func updateButton() {
        if cardIsValid && isHolderNameValid && expDateIsValid && isCVVLengthValid {
            buttonBgColor = .green
            disableButton = false
        } else {
            buttonBgColor =  .gray.opacity(0.5)
            disableButton = true
        }
    }
    private func getPayingMSISDN() -> String {
        creditCardVm.isSomeoneElsePaying ? creditCardVm.fem.accountNumber : AppStorageManager.getPhoneNumber()
    }
}

struct CardDetailsView_Previews: PreviewProvider {
    struct CardDetailsViewPreviewHolder: View {
        @State var cardDetails: CardDetails = .init()
        var body: some View {
            EnterCardDetailsView(cardDetails: $cardDetails)
        }
    }
    static var previews: some View {
        CardDetailsViewPreviewHolder()
            .environmentObject(CreditCardDI.createCreditCardViewModel())
    }
}


extension EnterCardDetailsView {
    private static let DEFAULT_CHECK_OUT_URL =
                "https:beep2.cellulant.com:9001/hub/api/mulaProxy/mulaWebCardUI/"
    private static let DEFAULT_SUCCESS_CALLBACK_URL = "https://merchant.com/web_hook_url.php"
    private static let CARD_CHARGE_SUCCESS =
               "https://beep2.cellulant.com:9001/hub/api/mulaProxy/mulaWebCardUI/src/DisplayStatus.php?"
}


func getCreditCardNameUsingCardNumber(creditCardNumber: String?) -> CardType {
    var result = CardType.none
    guard let number = creditCardNumber else {
        return result
    }
    if !number.isEmpty {
        let regVisa = #/^4[0-9]{12}(?:[0-9]{3})?$/#
        let regMaster = #/^5[1-5][0-9]{14}$/#
        let regExpress = #/^3[47][0-9]{13}$/#
        let regDiners = #/^3(?:0[0-5]|[68][0-9])[0-9]{11}$/#
        let regDiscover = #/^6(?:011|5[0-9]{2})[0-9]{12}$/#
        let regJCB = #/^(?:2131|1800|35\\d{3})\\d{11}$/#
        let regCarteBlanche = #/^389[0-9]{11}$/#
        let regEnRoute = #/^2(?:014|149)[0-9]{11}$/#
        
        result = literalMatch(pattern: regVisa, word: number) ? .visa : result
        result = literalMatch(pattern: regMaster, word: number) ? .mastercard : result
        result = literalMatch(pattern: regExpress, word: number) ? .amex : result
        result = literalMatch(pattern: regDiners, word: number) ? .DINERS : result
        result = literalMatch(pattern: regDiscover, word: number) ? .discover : result
        result = literalMatch(pattern: regJCB, word: number) ? .jcb : result
        result = literalMatch(pattern: regCarteBlanche, word: number) ? .CarteBlanche : result
    }
    return result
 }


func literalMatch(pattern: Regex<Substring>, word: String) -> Bool {
    var result = false
    if let match = word.firstMatch(of: pattern) {
        result = match.output == word
    }
    return result
}
