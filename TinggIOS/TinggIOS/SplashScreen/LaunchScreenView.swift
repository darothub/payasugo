//
//  LaunchScreenView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/10/2022.
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
/// This view display the splash screen on launch.
///
/// This is the first screen  of ``TinggIOSApp``.
public struct LaunchScreenView: View {
    @EnvironmentObject var navigation: NavigationUtils
    @State var colorTint:Color = .blue
    /// Creates a view that display the splash screen
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
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    navigation.navigationStack = [.intro]
//                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigation()
            
        }
    }
}
/// Struct responsible for preview of changes in Xcode
struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(NavigationUtils())
            .environmentObject(OnboardingDI.createOnboardingViewModel())
            .environmentObject(HomeDI.createHomeViewModel())
            .environmentObject(CreditCardDI.createCreditCardViewModel())
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

