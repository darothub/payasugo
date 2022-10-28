//
//  TingIOSApp.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//

import Core
import Home
import Onboarding
import SwiftUI
import Theme
@main
struct TinggIOSApp: App {
    @StateObject var enviromentUtils = EnvironmentUtils()
    @StateObject var navigation = NavigationUtils()
    @StateObject var ovm = OnboardingDI.createOnboardingViewModel()
    @StateObject var hvm = HomeDI.createHomeViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                appBody()
            }
        }
    }
    @ViewBuilder
    fileprivate func appBody() -> some View {
        ZStack {
            NavigationLink(destination: destination, isActive: $navigation.navigatePermission) {
                LaunchScreenView()
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(navigation)
            }
        }
        .onAppear {
              UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
              print(FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path)
        }
    }
    @ViewBuilder
    var destination: some View {
        switch navigation.screen {
        case .home:
            HomeBottomNavView()
        case .intro:
            IntroView()
                .navigationBarHidden(true)
                .environmentObject(navigation)
                .environmentObject(ovm)
        case .buyAirtime:
            BuyAirtimeView(airtimeServices: hvm.airTimeServices)
        }
    }
}
