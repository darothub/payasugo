//
//  TingIOSApp.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//
import Airtime
import Bills
import CreditCard
import Core
import CoreNavigation
import Checkout
import Permissions
import Onboarding
import SwiftUI
import Theme
import CoreUI
import FreshChat
import CommonCrypto
import Security
import CryptoSwift
import CryptoKit

@main
/// This is entry point into the application.
/// The first screen displayed to the user is the ``LaunchScreenView``.
/// The ``TinggIOSApp`` initialises the ``navigation`` and viewmodel

struct TinggIOSApp: App, CheckoutListener {
    @UIApplicationDelegateAdaptor(FirebaseAppDelegate.self) var appDelegate
    @Environment(\.colorScheme) var colorScheme
    @StateObject var navigation = NavigationManager()
    @StateObject var checkoutVm: CheckoutViewModel = CheckoutDI.createCheckoutViewModel()
    @StateObject var contactViewModel: ContactViewModel = .init()
    @StateObject var ccvm = CreditCardDI.createCreditCardViewModel()
    @StateObject var hvm = HomeDI.createHomeViewModel()
    @StateObject private var freshchatWrapper = FreshchatWrapper()
    @StateObject var firebaseManager = FirebaseDatabaseManager()
    @State private var sheetHeight: CGFloat = .zero
  
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .environmentObject(navigation)
                .environmentObject(contactViewModel)
                .environmentObject(ccvm)
                .environmentObject(hvm)
                .environmentObject(freshchatWrapper)
                .showCheckoutModifier($checkoutVm.showView, checkoutListener: self)
                .environmentObject(checkoutVm)
                .customDialog(
                    isPresented: $checkoutVm.showBundles,
                    backgroundColor: .constant(.clear),
                    cancelOnTouchOutside: .constant(true)
                ) {
                    BundleSelectionView(model: $checkoutVm.bundleModel)
                        .environmentObject(checkoutVm)
                }
                .onAppear {
                    UITextField.appearance().keyboardAppearance = .light
                    UITabBar.appearance().backgroundColor = colorScheme == .dark ? UIColor.white : UIColor.white
                    Log.d(message: FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path)
                    navigation.setHomeView(
                        view:
                        getHomeView()
                    )
//                    let base64String = "xFkm7YjUg28IJihFsDOsaumTSCKZmKrfu2l2A+56CT5va09R/JP5BvftHydAv8jPVrnF9JtLo+pMvbI7pG7lIli5xOCym8RdM/3NPVjeVIAEsQ777TWk7JYrg25oUhh1SdzLXR75ztHYeM6tnThdj29gPFxhzDhgx4ShA5pb2ImhinVRHF1v2BEZ3rBhwS/JstEMf+XM6zHZznITOp05Zv8rTe/Cw+qV8URzAT/e15XuvPk="
//                    let secretbase64String = "DsA91rE4AXNNVV5KkpOzJJuZ+dVOR1087UUCgSg5Gk8="
//                    let ivbase64String = "ezzAmk5S9yMciqK+"
//                    let result = TinggSecurity.symmetricDecrypt(ciphertextBase64: base64String, secretKeyBase64: secretbase64String, ivBase64: ivbase64String)
//                    Log.d(message: result ?? "NOthing")

                }
                .task {
                    firebaseManager.handleAuthCredentials()
                    do {
                        if let url = hvm.getJKSFileUrl() {
                            let (privateKey, publicKey) =  try await hvm.getCryptoKeysFromJKSFile(url)
                            if let publicKeyData = TinggSecurity.secKeyToData(publicKey), let privateKeyData = TinggSecurity.secKeyToData(privateKey) {
                                hvm.savePublicKeyAsData(publicKeyData)
                                hvm.savePrivateKeyAsData(privateKeyData)
                            }
                        }
                    } catch {
                        hvm.uiModel = UIModel.error(error.localizedDescription)
                    }
                }
                .handleUIState(uiState: $hvm.uiModel)
        }

    }
    func checkoutView() -> some View {
        return CheckoutView(listener: self)
            .environmentObject(checkoutVm)
            .environmentObject(contactViewModel)
            .environmentObject(navigation)
          
    }

    func getHomeView() -> AnyView {
        AnyView(
            HomeBottomNavView()
                .environmentObject(checkoutVm)
                .environmentObject(hvm)
                .environmentObject(freshchatWrapper)
                .environmentObject(contactViewModel)
        )
    }
    func onCheckoutSuccess(checkoutType: String, response: BaseDTOprotocol) {
        //
    }
    
    func navigateToInvoicePage() {
        checkoutVm.showView = false
        navigation.navigateTo(
            screen: HomeScreen.home(HomeBottomNavView.BILL, .second)
        )
    }
    func onAddNewBillClick() {
        addNewBill()
    }
    func onAddNewCardClick() {
        navigation.navigateTo(screen: CreditCardScreen.enterCardDetailsScreen)
    }
    fileprivate func addNewBill() {
        let category = Observer<CategoryEntity>().getEntities().first { $0.categoryID == checkoutVm.currentService.categoryID }
        let services = checkoutVm.services.filter { $0.categoryID == checkoutVm.currentService.categoryID }
        if category != nil {
            let item = TitleAndListItem(title: category!.categoryName, services: services)
            withAnimation {
                checkoutVm.showView = false
                navigation.navigateTo(screen:  BillsScreen.categoriesAndServices([item]))
            }
            return
        }

        if checkoutVm.currentService.isAirtimeService {
            navigation.navigateTo(screen: BuyAirtimeScreen.buyAirtime(checkoutVm.currentService.serviceName))
        }
    }
}
struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

