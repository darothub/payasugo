//
//  SavedCardsView.swift
//
//
//  Created by Abdulrasaq on 03/08/2023.
//
import Core
import CoreNavigation
import CoreUI
import SwiftUI
import Theme
import Pin

public struct SavedCardsView: View, OnEnterPINListener {
    @StateObject var creditCardVm = CreditCardDI.createCreditCardViewModel()
    @State var cardList: [CardDetails] = []
    @State var showPinDialog = false
    @State var pin = ""
    @State var nextActionAfterPinInput = ""
    @EnvironmentObject var navigation: NavigationManager
    public init() {
        //
    }

    public var body: some View {
        VStack {
            List(creditCardVm.cardList, id: \.cardNumber) { item in
                SingleCardItemView(cardItem: item)
                    .onTapGesture {
                        if !item.isActive {
                            navigation.navigateTo(
                                screen: CreditCardScreen.activateCardScreen(item)
                            )
                        }
                    }
            }
        }
        .onAppear {
            creditCardVm.cardList = creditCardVm.populateSavedCards()
        }
        .navigationTitle("Saved cards")
        .attachFab(backgroundColor: PrimaryTheme.getColor(.primaryColor)) {
            showPinDialog = true
        }
        .attachEnterPinDialog(showPinDialog: $showPinDialog, pin: pin, onFinish: $nextActionAfterPinInput, listener: self)
    }

    public func onFinish(_ otp: String, next: String) {
        let isValidPin = creditCardVm.validatePin(pin: otp)
        if isValidPin {
            showPinDialog = false
            navigation.navigateTo(screen: CreditCardScreen.enterCardDetailsScreen)
        } else {
            creditCardVm.uiModel = UIModel.error("Invalid pin/Pin not set")
        }
    }
}

#Preview {
    SavedCardsView()
}

struct SingleCardItemView: View {
    @State var cardItem: CardDetails = .init()
    var body: some View {
        HStack {
            RectangleImageCardView(size: CGSize(width: 60, height: 70), imageUrl: cardItem.imageUrl, radius: 0, y: 0)
            VStack(alignment: .leading) {
                Text(cardItem.cardNumber)
                Text(cardItem.suffix)
            }.font(.subheadline)
            Spacer()
            Menu {
                Button("Delete", action: {
                })
            } label: {
                Image(systemName: "info.circle")
            }
        }
        .padding(.horizontal, 10)
    }
}
