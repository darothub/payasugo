//
//  CreditCardNavigationModifier.swift
//
//
//  Created by Abdulrasaq on 03/08/2023.
//

import Core
import CoreUI
import Foundation
import SwiftUI
import CoreNavigation
import FreshChat
public struct CreditCardNavigationModifier: ViewModifier {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject private var freshchatWrapper: FreshchatWrapper
    public func body(content: Content) -> some View {
        content
            .navigationDestination(for: CreditCardScreen.self, destination: { screen in
                switch screen {
                case .enterCardDetailsScreen:
                    EnterCardDetailsView()
                        .environmentObject(navigation)
                case .savedCardScreen:
                    SavedCardsView()
                        .environmentObject(navigation)
                case .activateCardScreen(let cardDetails):
                    ActivateCardView()
                        .setCardDetails(cardDetails as! CardDetails)
                        .environmentObject(navigation)
                }
            })
    }
}

extension View {
    public func creditCardNavigation() -> some View {
        modifier(CreditCardNavigationModifier())
    }
}
