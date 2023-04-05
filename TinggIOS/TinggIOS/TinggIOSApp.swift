//
//  TingIOSApp.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//
import CreditCard
import Core
import Checkout
import Permissions
import Home
import Onboarding
import SwiftUI
import Theme

@main
/// This is entry point into the application.
/// The first screen displayed to the user is the ``LaunchScreenView``.
/// The ``TinggIOSApp`` initialises the ``navigation`` and viewmodel

struct TinggIOSApp: App {
    @StateObject var navigation = NavigationUtils()
    @StateObject var ovm = OnboardingDI.createOnboardingViewModel()
    @StateObject var  hvm = HomeDI.createHomeViewModel()
    @StateObject var checkoutVm: CheckoutViewModel = CheckoutDI.createCheckoutViewModel()
    @StateObject var contactViewModel: ContactViewModel = .init()
    @StateObject var ccvm = CreditCardDI.createCreditCardViewModel()
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .environmentObject(navigation)
                .environmentObject(ovm)
                .environmentObject(hvm)
                .environmentObject(checkoutVm)
                .environmentObject(contactViewModel)
                .environmentObject(ccvm)
                .sheet(isPresented: $checkoutVm.showView) {
                    checkoutView()
                }
                .onAppear {
                    Log.d(message: FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path)
                }
        }

    }
    func checkoutView() -> some View {
        return  CheckoutView()
            .environmentObject(checkoutVm)
            .environmentObject(contactViewModel)
            .environmentObject(navigation)
            .presentationDetents([.large])
          
    }
    
    func showContactView() -> some View {
        return ContactRowView(listOfContactRow: contactViewModel.listOfContact.sorted(by: <)){contact in
            contactViewModel.selectedContact = contact.phoneNumber
        }
    }
}
