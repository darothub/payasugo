//
//  NavigationModifier.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 28/01/2023.
//
import Airtime
import Bills
import CreditCard
import Core
import CoreUI
import CoreNavigation
import Checkout
import Onboarding
import Permissions
import Pin
import SwiftUI
import Theme
import FreshChat
struct NavigationModifier: ViewModifier, ServicesListener {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var  hvm: HomeViewModel
    @EnvironmentObject var checkout: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var ccvm: CreditCardViewModel
    @EnvironmentObject private var freshchatWrapper: FreshchatWrapper
    @State var colorTint:Color = .blue
    func body(content: Content) -> some View {
        content
            .changeTint($colorTint)
            .navigationDestination(for: HomeScreen.self) { screen in
                switch screen {
                case .profile:
                    EditProfileView()
                case .paymentOptions:
                    PaymentOptionsView()
                case .settings:
                    SettingsView()
                case .support:
                    SupportView()
                        .environmentObject(freshchatWrapper)
                case .about:
                    AboutView()
                case let .home(bottomNavTab, billViewTab):
                    if bottomNavTab.isEmpty {
                        HomeBottomNavView(selectedTab: HomeBottomNavView.HOME, billViewTab: Tab.first)
                            .environmentObject(checkout)
                            .environmentObject(hvm)
                            .environmentObject(freshchatWrapper)
                            .environmentObject(contactViewModel)
                    } else {
                        HomeBottomNavView(selectedTab: bottomNavTab, billViewTab: billViewTab)
                            .environmentObject(checkout)
                            .environmentObject(hvm)
                            .environmentObject(freshchatWrapper)
                            .environmentObject(contactViewModel)
                    }
                  
                case .intro:
                    IntroView()
                        .navigationBarHidden(true)
//                        .environmentObject(navigation)
                        .environmentObject(freshchatWrapper)
                case .pinCreationView:
                    EnterPinFullScreenView()
                case let .cardDetailsView(response, invoice):
                    EnterCardDetailsView(cardDetails: $checkout.cardDetails, createChannelResponse: response as? CreateCardChannelResponse, invoice: invoice as? Invoice)
//                        .environmentObject(navigation)
                    
                default:
                    EmptyView()
                }
            }
            .navigationDestination(for: NavigationHome.self) { screen in
                navigation.getHomeView()
                    .environmentObject(checkout)
                    .environmentObject(hvm)
                    .environmentObject(freshchatWrapper)
                    .environmentObject(contactViewModel)
            }
            .navigationDestination(for: Settings.self) { screen in
                SettingsView()
            }
            .billsNavigation(quickTopUpListener: self)
            .airtimesNavigation()
            .pinNavigation()
         

    }
    func onQuicktop(serviceName: String) {
        log(message: serviceName)
        navigation.navigateTo(screen: BuyAirtimeScreen.buyAirtime(serviceName))
    }
}

extension View {
    func navigation() -> some View {
        modifier(NavigationModifier())
    }
}
