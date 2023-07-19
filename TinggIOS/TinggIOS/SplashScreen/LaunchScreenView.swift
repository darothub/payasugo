//
//  LaunchScreenView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/10/2022.
//
import Airtime
import CreditCard
import CoreNavigation
import Core
import CoreUI
import Checkout
import Onboarding
import Permissions
import Pin
import SwiftUI
import Theme
import RealmSwift
import Foundation
import Bills
/// This view display the splash screen on launch.
///
/// This is the first screen  of ``TinggIOSApp``.
public struct LaunchScreenView: View, ServicesListener {
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject var mvm: MainViewModel
    @State var colorTint:Color = .blue
    /// Creates a view that display the splash screen
    public init() {
        //
    }
    public var body: some View {
        NavigationStack(path: navigation.getNavigationStack()) {
            NavigationLink(value: HomeScreen.intro) {
                ZStack {
                    background
                    image
                        .accessibility(identifier: "tinggsplashscreenlogo")
                }.onAppear {
                    let userAlreadyLoggedIn = AppStorageManager.getIsLogin()
                    if userAlreadyLoggedIn {
                        gotoHomeView()
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        navigation.navigateTo(screen: HomeScreen.intro)
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
         
            .navigation()
            .billsNavigation(quickTopUpListener: self)
            .airtimesNavigation()
            .navigationDestination(for: NavigationHome.self) { screen in
                navigation.getHomeView()
            }
            
        }
        .transition(.move(edge: .bottom))
    }
    fileprivate func gotoHomeView() {
        withAnimation {
            navigation.navigateTo(screen: HomeScreen.home(HomeBottomNavView.HOME, Tab.first))
        }
    }
    public func onQuicktop(serviceName: String) {
        log(message: serviceName)
        navigation.navigateTo(screen: BuyAirtimeScreen.buyAirtime(serviceName))
    }
}
/// Struct responsible for preview of changes in Xcode
struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(NavigationManager())
            .environmentObject(CreditCardDI.createCreditCardViewModel())
            .environmentObject(MainViewModel(systemUpdateUsecase: .init()))
    }
}

private extension LaunchScreenView {
    var background: some View {
        PrimaryTheme.getColor(.secondaryColor)
            .edgesIgnoringSafeArea(.all)
    }
    var image: some View {
        PrimaryTheme.getImage(image: .tinggSplashScreenIcon)
            .renderingMode(.template)
            .foregroundColor(Color.white)
    }
}





