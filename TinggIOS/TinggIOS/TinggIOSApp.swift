//
//  TingIOSApp.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//
import CreditCard
import Core
import CoreNavigation
import Checkout
import Permissions
import Home
import Onboarding
import SwiftUI
import Theme
import CoreUI

@main
/// This is entry point into the application.
/// The first screen displayed to the user is the ``LaunchScreenView``.
/// The ``TinggIOSApp`` initialises the ``navigation`` and viewmodel

struct TinggIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.colorScheme) var colorScheme
    @StateObject var navigation = NavigationUtils()
    @StateObject var checkoutVm: CheckoutViewModel = CheckoutDI.createCheckoutViewModel()
    @StateObject var contactViewModel: ContactViewModel = .init()
    @StateObject var ccvm = CreditCardDI.createCreditCardViewModel()
    @StateObject var hvm = HomeDI.createHomeViewModel()
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .environmentObject(navigation)
                .environmentObject(checkoutVm)
                .environmentObject(contactViewModel)
                .environmentObject(ccvm)
                .environmentObject(hvm)
                .sheet(isPresented: $checkoutVm.showView) {
                    checkoutView()
                        .presentationDetents([.fraction(0.7)])
                        .presentationBackground(.thinMaterial)
                        .presentationContentInteraction(.scrolls)
                }
                .customDialog(
                    isPresented: $hvm.showBundles,
                    backgroundColor: .constant(.clear),
                    cancelOnTouchOutside: .constant(true)
                ) {
                    BundleSelectionView(model: $hvm.bundleModel)
                }
                .onAppear {
                    UITextField.appearance().keyboardAppearance = .light
                    UITabBar.appearance().backgroundColor = colorScheme == .dark ? UIColor.white : UIColor.white

                    Log.d(message: FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path)
                }
        }

    }
    func checkoutView() -> some View {
        return  CheckoutView()
            .environmentObject(checkoutVm)
            .environmentObject(contactViewModel)
            .environmentObject(navigation)
          
    }
    
    func showContactView() -> some View {
        return ContactRowView(listOfContactRow: contactViewModel.listOfContact.sorted(by: <)){contact in
            contactViewModel.selectedContact = contact.phoneNumber
        }
    }
}



