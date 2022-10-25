//
//  LaunchScreenView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/10/2022.
//

import Core
import Home
import Onboarding
import SwiftUI
import Theme
public struct LaunchScreenView: View {
    @EnvironmentObject var splashScreenWatcher: EnvironmentUtils
    @EnvironmentObject var navigation: NavigationUtils
    @EnvironmentObject var ovm: OnboardingViewModel
    @StateObject var  hvm = HomeDI.createHomeViewModel()
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public var body: some View {
        NavigationStack(path: $navigation.navigationStack) {
            ZStack {
                background
                image
                    .accessibility(identifier: "tinggsplashscreenlogo")
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    navigation.navigationStack = [.intro]
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(for: Screens.self) { screen in
                switch screen {
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
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(EnvironmentUtils())
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
