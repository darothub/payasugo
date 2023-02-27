//
//  NavigationModifier.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 28/01/2023.
//
import CreditCard
import Core
import Checkout
import Home
import Onboarding
import Permissions
import Pin
import SwiftUI
import Theme
struct NavigationModifier: ViewModifier {
    @EnvironmentObject var navigation: NavigationUtils
    @EnvironmentObject var ovm: OnboardingViewModel
    @EnvironmentObject var  hvm: HomeViewModel
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
                        .environmentObject(ovm)
                case .buyAirtime:
                    BuyAirtimeView()
                        .environmentObject(checkout)
                        .environmentObject(contactViewModel)
                case let .billers(billers):
                    BillersView(billers: billers)
                        .environmentObject(hvm)
                        .onAppear {
                            colorTint = .blue
                        }
                case .categoriesAndServices(let items):
                    CategoriesAndServicesView(categoryNameAndServices: items)
            
                case .billFormView(let billDetails):
                    BillFormView(billDetails: .constant(billDetails))
                        
                case let .nominationDetails(invoice, nomination):
                    NominationDetailView(invoice: invoice, nomination:  nomination)
                        .onAppear {
                            colorTint = .white
                        }
                case let .billDetailsView(invoice, service):
                    BillDetailsView(
                        fetchBill: invoice,
                        service: service
                    )
                case .pinCreationView:
                    CreditCardPinView(pinPermission: $checkout.pinPermission, pin: $checkout.pin, confirmPin: $checkout.confirmPin, pinIsCreated: $checkout.pinIsCreated)
                case .securityQuestionView:
                    SecurityQuestionView(selectedQuestion: $checkout.selectedQuestion, answer: $checkout.answer)
                case let .cardDetailsView(response, invoice):
                    EnterCardDetailsView(cardDetails: $checkout.cardDetails, createChannelResponse: response, invoice: invoice)
                        .environmentObject(navigation)
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
