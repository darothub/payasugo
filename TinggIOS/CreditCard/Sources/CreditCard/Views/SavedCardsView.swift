//
//  SavedCardsView.swift
//
//
//  Created by Abdulrasaq on 03/08/2023.
//
import Core
import CoreNavigation
import CoreUI
import Pin
import SwiftUI
import Theme

public struct SavedCardsView: View, OnEnterPINListener {
    @StateObject var creditCardVm = CreditCardDI.createCreditCardViewModel()
    @State var cardList: [CardDetails] = []
    @State var showPinDialog = false
    @State var pin = ""
    @State var nextActionAfterPinInput = ""
    @State var currentCardDetails = CardDetails()
    @State var showConfirmationAlert = false
    @EnvironmentObject var navigation: NavigationManager
    
    public init() {
        //
    }

    public var body: some View {
        VStack {
            List {
                ForEach(creditCardVm.cardList, id: \.cardNumber) { item in
                    SingleCardItemView(cardItem: item) { cardItem in
                        navigation.navigateTo(
                            screen: CreditCardScreen.activateCardScreen(cardItem)
                        )
                    } onDelete: { cardItem in
                        var c = cardItem
                        makeDeleteRequest(using: &c)
                    }
                }.onDelete(perform: deleteCard(at:))
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
        .handleViewStatesMods(uiState: creditCardVm.$uiModel)
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Confirm").font(.headline),
                message: Text("Are you sure you want to delete \(currentCardDetails.merchantPayer.clientName) \(currentCardDetails.cardType) \(currentCardDetails.getMaskedPan())").font(.caption),
                primaryButton: .default(Text("OK"), action: {
                    makeDeleteRequest(using: &currentCardDetails)
                    showConfirmationAlert = false
                }),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .onDisappear {
            creditCardVm.uiModel = UIModel.nothing
        }
    }
    func deleteCard(at offSet: IndexSet) {
        showConfirmationAlert = true
        currentCardDetails = creditCardVm.cardList[offSet.first!]
    }
    func makeDeleteRequest(using cardDetails: inout CardDetails) {
        let profile = Observer<Profile>().getEntities().first!
        if let profileId = profile.profileID {
            let request = RequestMap.Builder()
                .add(value: "MCD", for: .SERVICE)
                .add(value: "DELETE", for: .ACTION)
                .add(value: profileId, for: "PROFILE_ID")
                .add(value: cardDetails.getEncryptedAlias(), for: "CARD_ALIAS")
                .build()
            log(message: request)
            creditCardVm.deleteCardRequest(request: request)
        }
       
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
    @State var showConfirmationAlert = false
    var onBodyClick: (CardDetails) -> Void = { _ in }
    var onDelete: (CardDetails) -> Void = { _ in }

    var body: some View {
        HStack {
            RectangleImageCardView(size: CGSize(width: 60, height: 70), imageUrl: cardItem.imageUrl, radius: 0, y: 0)
            VStack(alignment: .leading) {
                Text(cardItem.getMaskedPan())
                HStack {
                    Text(cardItem.suffix)
                    Text("INACTIVE")
                        .background(.gray)
                        .foregroundColor(.white)
                        .showIfNot($cardItem.isActive)
                }
            }
            .font(.subheadline)
            .onTapGesture {
                if !cardItem.isActive {
                    onBodyClick(cardItem)
                }
            }
            Spacer()
            Menu {
                Button("Delete", action: {
                    showConfirmationAlert = true
                })
            } label: {
                Image(systemName: "info.circle")
            }
        }
        .font(.caption)
        .padding(.horizontal, 5)
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Confirm").font(.headline),
                message: Text("Are you sure you want to delete \(cardItem.merchantPayer.clientName) \(cardItem.cardType) \(cardItem.getMaskedPan())").font(.caption),
                primaryButton: .default(Text("OK"), action: {
                    print("OK tapped")
                    onDelete(cardItem)
                    showConfirmationAlert = false
                }),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}
