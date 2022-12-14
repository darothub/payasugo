//
//  TingIOSApp.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//

import Core
import Permissions
import Home
import Onboarding
import SwiftUI
import Theme
@main
/// This is entry point into the application.
/// The first screen displayed to the user is the ``LaunchScreenView``.
/// The ``TinggIOSApp`` initialises the ``navigation`` and viewmodels
struct TinggIOSApp: App {
    @StateObject var navigation = NavigationUtils()
    @StateObject var ovm = OnboardingDI.createOnboardingViewModel()
    @StateObject var  hvm = HomeDI.createHomeViewModel()
    @StateObject var checkout: Checkout = .init()
    @StateObject var contactViewModel: ContactViewModel = .init()
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .environmentObject(navigation)
                .environmentObject(ovm)
                .environmentObject(hvm)
                .environmentObject(checkout)
                .environmentObject(contactViewModel)
                .onAppear {
                    print(FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path)
                }
                .sheet(isPresented: $contactViewModel.showContact, content: {
                    showContactView()
                })
                .sheet(isPresented: $checkout.showCheckOutView) {
                    BuyAirtimeCheckoutView()
                        .presentationDetents([.fraction(0.9)])
                        .environmentObject(checkout)
                        .environmentObject(contactViewModel)
                }
        }

    }
    
    func showContactView() -> some View {
        return ContactRowView(listOfContactRow: contactViewModel.listOfContact.sorted(by: <)){contact in
            contactViewModel.selectedContact = contact.phoneNumber
            contactViewModel.showContact = false
        }
    }
}
