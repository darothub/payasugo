//
//  EnterCardDetailsView.swift
//
//
//  Created by Abdulrasaq on 12/01/2023.
//
import Combine
import Core
import CoreNavigation
import CoreUI
import Permissions
import SwiftUI
import Theme
public struct EnterCardDetailsView: View {
    // MARK: Variables

    @EnvironmentObject var creditCardVm: CreditCardViewModel
    @EnvironmentObject var navigation: NavigationManager
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
    @State private var isValidExpDate = false
    @State private var cardIsValid = false
    @State private var isValidCVV = false
    @State private var isValidHolderName = false
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
    @State var isValidCardNumber = false
    @State var cardDetails: CardDetails = .init()
    @State var cardNumberCount = 0
    @State var cardCVVCount = 0
    @State var holderNameTFTag = 1
    @State var expDateTFTag = 2
    @State var cvvTFTag = 3
    @State var addressTFTag = 4
    var invoice: Invoice?
    @FocusState var focus: Int?
    public init(createChannelResponse: CreateCardChannelResponse? = nil, invoice: Invoice? = nil) {
        self.createChannelResponse = createChannelResponse
        self.invoice = invoice
    }

    public var body: some View {
        ScrollView {
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
                            .font(.caption)

                        Text("Card details are saved securely")
                            .font(.caption)
                    }
                    
                    VStack {
                        TextFieldAndRightIcon (
                            number: $cardDetails.cardNumber,
                            iconName: cardIcon,
                            placeHolder: cardNumberHolderText) { value in
                                isValidCardNumber = validateCardNumber(value)
                                if isValidCardNumber {
                                    focus = 1
                                }
                                return isValidCardNumber
                            } onImageClick: {
                                print("click card")
                            }
                            .focused($focus, equals: 0)

                        HStack {
                            Spacer()
                            Text("\(cardNumberCount)/16")
                                .font(.caption)
                        }
                    }
                    TextFieldView(
                        fieldText: $cardDetails.holderName,
                        label: "", placeHolder: "Card holder's name"
                    ) { str in
                        let isValidHolderName = validateHolderName(str)
                        return isValidHolderName
                    }
                    .focused($focus, equals: 1)

                    HStack(alignment: .top) {
                        TextFieldView(
                            fieldText: $cardDetails.expDate,
                            label: "", placeHolder: "Exp date",
                            type: .numberPad
                        ) { str in
                            let isValidExp = validateExpDate(str)
                            if isValidExp {
                                focus = 3
                            }
                            return isValidExp
                        }
                        .focused($focus, equals: 2)
                        Spacer()
                        VStack {
                            TextFieldView(
                                fieldText: $cardDetails.cvv,
                                label: "", placeHolder: "CVV",
                                type: .numberPad
                            ) { str in
                                let validCVV = validateCVV(str)
                                if validCVV {
                                    focus = 4
                                }
                                return validCVV
                            }
                            .focused($focus, equals: 3)
                            HStack {
                                Spacer()
                                Text("\(cardCVVCount)/3")
                                    .font(.caption)
                            }
                        }
                    }

                    TextFieldView(
                        fieldText: $cardDetails.address,
                        label: "",
                        placeHolder: "Address"
                    ) { str in
                        let isValidAddress = validateAddress(str)
                        if isValidAddress {
                            focus = 5
                        }
                        return isValidAddress
                    }
                    .focused($focus, equals: 4)
                    Spacer()
                    // Button
                    TinggButton(
                        backgroundColor: buttonBgColor,
                        buttonLabel: "Continue",
                        padding: 0
                    ) {
                        submitCardDetails()
                    }
                    .disabled(disableButton)
                    .focused($focus, equals: 5)
                }
                .padding()
                // WebView
                HTMLView(
                    url: htmlString,
                    webViewUIModel: creditCardVm.uiModel,
                    didFinish: { url in
                        handleWebViewFinishEvent(url: url)
                    }, onTryAgain: {
                        submitCardDetails()
                    }
                ).showIf($showWebView)
            }
            .onReceive(Just(cardDetails.cardNumber)) { newValue in
                cardNumberCount = newValue.replacingOccurrences(of: " ", with: "").count
                if newValue.isEmpty {
                    withAnimation(.linear(duration: 1.5)) {
                        cardImage = .cardTempIcon
                    }
                }
            }
            .onReceive(Just(cardDetails.cvv)) { newValue in
                cardCVVCount = newValue.count
            }
            .handleViewStatesMods(uiState: creditCardVm.$uiModel) { content in
                log(message: content)
                createChannelResponse = (content.data as! CreateCardChannelResponse)
                successUrl = createChannelResponse!.successUrl
                checkoutUrl = createChannelResponse!.webUrl.isEmpty ? EnterCardDetailsView.DEFAULT_CHECK_OUT_URL : createChannelResponse!.webUrl
                let cvaKeyValueInRequest = createKeyValueAsRequest(createCardChannelResponse: createChannelResponse!)
                htmlString = createPostStringFromRequest(request: cvaKeyValueInRequest)
                showWebView = htmlString.isNotEmpty
            }
            .navigationTitle("Card")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                Button(action: {
                    if showWebView {
                        successUrl = ""
                        showWebView.toggle()
                    } else {
                        navigation.goBack()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Next") {
                        if cardIsValid {
                            focus = 1
                        } else if isValidHolderName {
                            focus = 2
                        } else if isValidExpDate {
                            focus = 3
                        } else if isValidCVV {
                            focus = 4
                        } else {
                            focus = 5
                        }
                    }
                }
            }
            .onDisappear {
                creditCardVm.uiModel = UIModel.nothing
            }
            .onChange(of: focus) { newValue in
                Log.d(message: "\(newValue)")
            }
        }
    }

    func validateHolderName(_ newValue: String) -> Bool {
        isValidHolderName = newValue.isEmpty ? false : true
        updateButton()
        return isValidHolderName
    }

    func validateCVV(_ newValue: String) -> Bool {
        isValidCVV = newValue.count < 3 ? false : true
        cardDetails.cvv = checkLength(newValue, length: 3)
        updateButton()
        return isValidCVV
    }

    func validateExpDate(_ newValue: String) -> Bool {
        cardDetails.expDate = checkLength(newValue, length: 5)
        cardDetails.expDate = cardDetails.expDate.applyDatePattern()
        isValidExpDate = isExpiryDateValid(expDate: cardDetails.expDate)
        updateButton()
        return isValidExpDate
    }

    func validateCardNumber(_ newValue: String) -> Bool {
        log(message: "here \(newValue)")
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
        }
        cardIsValid = cardCheck(number: newValue.replacingOccurrences(of: " ", with: ""))
        updateButton()
        return cardIsValid
    }

    func validateAddress(_ newValue: String) -> Bool {
        updateButton()
        return newValue.isNotEmpty
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
            list.append(key + "=\(value)")
        }
        return list.map { String($0) }.joined(separator: "&")
    }

    private func createKeyValueAsRequest(createCardChannelResponse: CreateCardChannelResponse) -> RequestMap {
        let request = getBaseRequestBuilderForPostCreateChannel(createCardChannelResponse: createCardChannelResponse)
            .add(value: "CARD_VALIDATION", for: "action")
            .build()
        log(message: request)
        return request
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
        let serviceDescription = "Payment of \(country.currency!) \(createCardChannelResponse.amount) for \(createCardChannelResponse.serviceName)  ."

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

        guard let msisdn = profile.msisdn else {
            throwError(message: "Invalid MSISDN")
        }
        guard let countryCode = country.countryCode else {
            throwError(message: "Invalid Country code")
        }
        guard let currencyCode = country.currency else {
            throwError(message: "Invalid Currency code")
        }
        log(message: cardDetails)
        successCallbackUrl = statusUrl.isEmpty ? EnterCardDetailsView.DEFAULT_SUCCESS_CALLBACK_URL : statusUrl
        log(message: cardDetails.holderName)
        let encyrptedHolderName = CreditCardUtil.encrypt(data: cardDetails.holderName)
        let encryptedCVV = CreditCardUtil.encrypt(data: cardDetails.cvv)
        let cardNumberWithoutWhiteSpace = cardDetails.cardNumber.removeWhitespace()
        let encyrptedCardNumber = CreditCardUtil.encrypt(data: cardNumberWithoutWhiteSpace)

        return RequestMap.Builder()
            .clear()
            .add(value: createCardChannelResponse.amount, for: "amount")
            .add(value: msisdn, for: "MSISDN")
            .add(value: uuidForVendor, for: "UUID")
            .add(value: currencyCode, for: "currencyCode")
            .add(value: serviceDescription, for: "serviceDescription")
            .add(value: countryCode, for: "countryCode")
            .add(value: "georgenwauran@gmailcom", for: "customerEmail")
            .add(value: userName, for: "customerFirstName")
            .add(value: cardDetails.getEncryptedExpDate(), for: "expiry")
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

    private func submitCardDetails() {
        if isValidHolderName && isValidExpDate && isValidCVV {
            let request = RequestMap.Builder()
                .add(value: "CREATE_CHANNEL_REQUEST", for: .ACTION)
                .add(value: "CVA", for: .SERVICE)
                .add(value: "0", for: "CHECK_MODE")
                .add(value: "", for: "EMAIL_ADDRESS")
                .add(value: cardDetails.address, for: "POSTAL_ADDRESS")
                .add(value: cardDetails.getEncryptedExpDate(), for: "EX_DATE")
                .add(value: cardDetails.getEncryptedAlias(), for: "SUFFIX")
                .add(value: cardDetails.getEncryptedPrefix(), for: "PREFIX")
                .add(value: cardDetails.getEncryptedAlias(), for: .CARD_ALIAS)
                .add(value: "1", for: "IS_MAIN")
                .build()
            log(message: request)
            log(message: cardDetails)

            Task { try await creditCardVm.createCreditCardChannel(tinggRequest: request) }
        } else {
            creditCardVm.uiModel = UIModel.error("Some details are missing")
        }
    }

    private func handleWebViewFinishEvent(url: String) {
        if url.contains(successUrl) || url.contains(EnterCardDetailsView.CARD_CHARGE_SUCCESS) {
            // intercept the GET params.
            // cuts to the parameters.
            let successPattern = #/SUCCESS=\w+/#
            if let successMatch = url.firstMatch(of: successPattern) {
                log(message: "\(successMatch)")
                let match = successMatch.output
                log(message: "\(String(describing: match))")
                let successValue = match.last!
                log(message: "\(String(describing: successValue))")
                let isSuccessful = successValue == "1" || successValue == "2"
                handleResult(isSuccessful, successValue)
            }
        }
    }

    fileprivate func updateTransactionHistory(_ raisedInvoice: Invoice?, _ amount: Double, _ customerName: String, _ accountNumber: String) {
        let payer = creditCardVm.currentPaymentProvider
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
    }

    fileprivate func handleResult(_ isSuccessful: Bool, _ successValue: Substring.Element) {
        if isSuccessful {
            isCardActivated = successValue == "2"
            let card = createAndAddCard()
            Observer<Card>().saveEntity(obj: card)
        } else if cardDetails.checkout && isSuccessful {
            creditCardVm.uiModel = UIModel.loading
            _ = createChannelResponse
            let raisedInvoice = invoice
            if let amount = createChannelResponse?.amount {
                if var rinv = raisedInvoice {
                    updateInvoice(&rinv, amount: amount)
                    Observer<Invoice>().saveEntity(obj: rinv)
                }
                let userMSISDN = Observer<Profile>().getEntities()[0].msisdn
//                let accountNumber = creditCardVm.fem.accountNumber
//                let customerName = getCustomerName(userMSISDN, accountNumber)
//                updateTransactionHistory(raisedInvoice, amount, customerName, accountNumber)
//                let content = UIModel.Content(statusMessage: "Updated invoice")
//                creditCardVm.uiModel = UIModel.content(content)
            }
        }
    }

    fileprivate func getCustomerName(_ userMSISDN: String?, _ accountNumber: String) -> String {
        var name: String = ""
        if creditCardVm.service.isAirtimeService && ((userMSISDN?.elementsEqual(accountNumber)) != nil) {
            name = "Me"
        } else if creditCardVm.service.isAirtimeService {
            Task {
                await contactVm.fetchPhoneContactsWIthoutUI { cr in
                    if cr.phoneNumber.elementsEqual(accountNumber) {
                        name = cr.phoneNumber
                    } else {
                        name = ""
                    }
                } onError: { error in
                    log(message: error.localizedDescription)
                }
            }
        }
        return name
    }

    private func createAndAddCard() -> Card {
        let card = Card()
        card.cardAlias = cardDetails.suffix
        card.customerAddress = cardDetails.address
        card.cardType = Card.TYPE_NORMAL
        card.activeStatus = isCardActivated ? Card.STATUS_ACTIVE : Card.STATUS_INACTIVE
        card.firstName = cardDetails.holderName.split(separator: " ").first?.description
        card.middleName = cardDetails.holderName.split(separator: " ")[2].description
        card.nameType = getCreditCardNameUsingCardNumber(creditCardNumber: cardDetails.cardNumber).rawValue
        card.suffix = ""
        card.validationServiceID = createChannelResponse?.serviceId
        return card
    }

    private func updateInvoice(_ raisedInvoice: inout Invoice, amount: Double) {
        raisedInvoice.amount = String(amount)
        raisedInvoice.hasPaymentInProgress = true
        let totalPaid = raisedInvoice.partialPaidAmount + amount
        switch true {
        case totalPaid > amount:
            raisedInvoice.partialPaidAmount = 0.0
            raisedInvoice.fullyPaid = true
            raisedInvoice.overPaid = true
        case totalPaid < amount:
            raisedInvoice.partialPaidAmount = totalPaid
            raisedInvoice.fullyPaid = false
            raisedInvoice.overPaid = false
        case totalPaid == amount:
            raisedInvoice.partialPaidAmount = 0.0
            raisedInvoice.fullyPaid = true
            raisedInvoice.overPaid = false
        default:
            log(message: "Default")
        }
    }

    private func updateButton() {
        if cardIsValid && isValidHolderName && isValidExpDate && isValidCVV {
            buttonBgColor = .green
            disableButton = false
        } else {
            buttonBgColor = .gray.opacity(0.5)
            disableButton = true
        }
    }

    private func getPayingMSISDN() -> String {
//        creditCardVm.isSomeoneElsePaying ? creditCardVm.fem.accountNumber : AppStorageManager.getPhoneNumber()
        return ""
    }
}

struct CardDetailsView_Previews: PreviewProvider {
    struct CardDetailsViewPreviewHolder: View {
        @State var cardDetails: CardDetails = .init()
        var body: some View {
            EnterCardDetailsView()
        }
    }

    static var previews: some View {
        CardDetailsViewPreviewHolder()
            .environmentObject(CreditCardDI.createCreditCardViewModel())
            .environmentObject(NavigationManager())
    }
}

extension EnterCardDetailsView {
    public static let DEFAULT_CHECK_OUT_URL =
        "https:beep2.cellulant.com:9001/hub/api/mulaProxy/mulaWebCardUI/"
    public static let DEFAULT_SUCCESS_CALLBACK_URL = "https://merchant.com/web_hook_url.php"
    public static let CARD_CHARGE_SUCCESS =
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
