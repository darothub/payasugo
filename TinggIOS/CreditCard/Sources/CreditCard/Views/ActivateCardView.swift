//
//  ActivateCardView.swift
//
//
//  Created by Abdulrasaq on 04/08/2023.
//
import Core
import CoreUI
import Theme
import SwiftUI
import Combine
import FreshChat
import CoreNavigation

public struct ActivateCardView: View {
    @StateObject private var freshchatWrapper: FreshchatWrapper = .init()
    @StateObject private var creditCardVm = CreditCardDI.createCreditCardViewModel()
    @EnvironmentObject var navigation: NavigationManager
    @Environment(\.cardDetails) var cardDetails
    @State private var backDegree = -90.0
    @State private var frontDegree = 0.0
    @State private var isFlipped = false
    @State private var cardFace = CardFaces.frontBeforeEdit
    @State var frontBackGroundColor:Color = .black
    @State var cardNumber: String = ""
    @State var holderName: String = ""
    @State var expDate: String = ""
    @State var cvv: String = ""
    @State var cardImage: PrimaryTheme.Images = .cardTempIcon
    @State var disableActivateCardButton = true
    @State var amount = ""
    @State var buttonBgColor: Color = .gray.opacity(0.5)
    @State var mutableCardDetails = CardDetails()
    let durationAndDelay : CGFloat = 0.3
    public init() {
        //
    }
    public var body: some View {
        VStack(spacing: 10) {
            CardTemplateFrontView(
                rotationDegree: $frontDegree,
                backGroundColor: $frontBackGroundColor,
                cardNumber: $cardNumber,
                holderName: $holderName,
                expDate: $expDate,
                image: $cardImage
            )
            Text("Card is not active")
                .font(.caption)
            Group {
                Text("In order to start using your debit/credit card, please activate it")
                    .font(.headline)
                Text("Activate your card by entering the amount deducted on your card from your statements")
                    .font(.caption)
            }.frame(maxWidth: .infinity, alignment: .leading)
            TextFieldView (
                fieldText: $amount,
                label: "", placeHolder: "Amount",
                type: .numberPad
            ) { str in
                validateAmount(str)
            }
            Spacer()
            TinggButton(
                backgroundColor: buttonBgColor,
                buttonLabel: "Activate card",
                padding: 0
            ) {
               //
            }.disabled(disableActivateCardButton)
           
            TinggButton(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Contact us",
                padding: 0
            ) {
                freshchatWrapper.showFreshchat()
            }
        }.padding()
        .onAppear(perform: {
            mutableCardDetails = cardDetails
            cardNumber = mutableCardDetails.cardNumber
            holderName = mutableCardDetails.holderName
            expDate = mutableCardDetails.expDate
        })
        .onReceive(Just(cardNumber), perform: { newValue in
            let _ = validateCardNumber(newValue)
        })
        .handleUIState(uiState: $creditCardVm.uiModel, showAlertonSuccess: true) { content in
            let data = content.data as! BaseDTO
            let card = creditCardVm.cards.first { $0.cardAlias == mutableCardDetails.suffix }
            card?.activeStatus = Card.STATUS_ACTIVE
        } action: {
            navigation.goBack()
        }
        
    }
    private func validateCardNumber(_ newValue: String) -> Bool {
        cardNumber = checkLength(newValue, length: 19)
        cardNumber = cardNumber.applyPattern()
        if cardNumber.starts(with: "5") {
            withAnimation(.linear(duration: 1.5)) {
                cardImage = .mastercardIcon
            }
        } else if cardNumber.starts(with: "4") {
            withAnimation(.linear(duration: 1.5)) {
                cardImage = .visa
            }
        }
        return  cardCheck(number: newValue.replacingOccurrences(of: " ", with: ""))
    }
    private func validateAmount(_ amount: String) -> Bool {
        if amount.isEmpty {
            return false
        } else {
            return true
        }
    }
    private func makevalidationRequest() {
        var request = RequestMap.Builder()
            .add(value: amount, for: .AMOUNT)
            .add(value: mutableCardDetails.getEncryptedAlias(), for: .CARD_ALIAS)
            .add(value: "VALIDATE_USER", for: .ACTION)
            .build()
        creditCardVm.validateUser(request: request)
    }
}

#Preview {
    ActivateCardView()
}
