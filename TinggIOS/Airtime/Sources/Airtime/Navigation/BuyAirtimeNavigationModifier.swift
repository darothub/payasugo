//
//  BuyAirtimeNavigationModifier.swift
//  
//
//  Created by Abdulrasaq on 18/07/2023.
//

import Foundation

import Checkout
import Core
import CoreUI
import Foundation
import Permissions
import SwiftUI
public struct BuyAirtimeNavigationModifier: ViewModifier {
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @State var colorTint:Color = .blue
    public func body(content: Content) -> some View {
        content
            .changeTint($colorTint)
            .navigationDestination(for: BuyAirtimeScreen.self, destination: { screen in
                switch screen {
                case .buyAirtime(let serviceName):
                    BuyAirtimeView(selectedServiceName: serviceName)
                        .environmentObject(checkoutVm)
                        .environmentObject(contactViewModel)
                }
            })
    }
}

extension View {
    public func airtimesNavigation() -> some View {
        modifier(BuyAirtimeNavigationModifier())
    }
}
