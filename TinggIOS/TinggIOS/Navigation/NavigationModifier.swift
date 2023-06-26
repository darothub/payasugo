//
//  NavigationModifier.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 28/01/2023.
//
import Airtime
import CreditCard
import Core
import CoreNavigation
import Checkout
import Home
import Onboarding
import Permissions
import Pin
import SwiftUI
import Theme
struct NavigationModifier: ViewModifier {
    @EnvironmentObject var navigation: NavigationUtils
//    @EnvironmentObject var  hvm: HomeViewModel
    @EnvironmentObject var checkout: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var ccvm: CreditCardViewModel
    @State var colorTint:Color = .blue
    func body(content: Content) -> some View {
        content
            .changeTint($colorTint)
            .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case .home:
                    HomeBottomNavView()
                        .environmentObject(checkout)

                case .intro:
                    IntroView()
                        .navigationBarHidden(true)
                        .environmentObject(navigation)
                case .buyAirtime(let serviceName):
                    BuyAirtimeView(selectedServiceName: serviceName)
                        .environmentObject(checkout)
                        .environmentObject(contactViewModel)
                case .categoriesAndServices(let items):
                    CategoriesAndServicesView(categoryNameAndServices: items as! [TitleAndListItem])

                case .pinCreationView:
                    CreditCardPinView(pinPermission: $checkout.pinPermission, pin: $checkout.pin, confirmPin: $checkout.confirmPin, pinIsCreated: $checkout.pinIsCreated)
                case .securityQuestionView:
                    SecurityQuestionView(selectedQuestion: $checkout.selectedQuestion, answer: $checkout.answer)
                case let .cardDetailsView(response, invoice):
                    EnterCardDetailsView(cardDetails: $checkout.cardDetails, createChannelResponse: response as? CreateCardChannelResponse, invoice: invoice as? Invoice)
                        .environmentObject(navigation)
                case .transactionListView(let model as TransactionItemModel):
                    EmptyView()
//                    TransactionListView(listOfModel: .constant(model))
                default:
                    EmptyView()
                }
            }
    }
}

extension View {
    func navigation() -> some View {
        modifier(NavigationModifier())
    }
}
