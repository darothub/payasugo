//
//  IntroView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//
import CoreUI
import Core
import CoreNavigation
import SwiftUI
import Theme
import FreshChat

/// Introduces the onboarding screens to the user
public struct IntroView: View {
    @State private var active = false
    @EnvironmentObject var navigation: NavigationUtils
    @EnvironmentObject private var freshchatWrapper: FreshchatWrapper

    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                topBackgroundDesign(
                    color: PrimaryTheme.getColor(.cellulantLightGray)
                ).frame(height: geo.size.height*0.5)
                tinggColoredLogo
                    .accessibility(identifier: "tingggreenlogo")
                IntroTabView(active: $active)
                    .environmentObject(navigation)
            }
            .background(.white)
            .onAppear {
                setPageIndicatorAppearance()
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .environmentObject(NavigationUtils())
            .environmentObject(FreshchatWrapper())
    }
}

/// Tabview displays the onboarding views in turn
struct IntroTabView: View {
    @Binding var active: Bool
    @EnvironmentObject var navigation: NavigationUtils
    var body: some View {
        VStack {
            TabView {
                onboardingViewListView()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .accessibility(identifier: "onboardingtabview")
            Spacer()
            getStartedButton()
        }
        .navigationDestination(for: OnboardingScreen.self, destination: { screen in
            switch screen {
            case .accountRegistration:
                PhoneNumberValidationView()
                    .environmentObject(navigation)
            default:
                IntroView()
            }
        })
    }
    @ViewBuilder
    /// Iterates over available onboarding screens
    /// - Returns: OnboardingView
    fileprivate func onboardingViewListView() -> some View {
        ForEach(onboardingItems(), id: \.info) { item in
            VStack {
                OnboadingView(onboadingItem: item)
                Spacer()
            }
        }
    }
    @ViewBuilder
    /// A button with `Get started` text
    /// - Returns: Button
    fileprivate func getStartedButton() -> some View {
        TinggButton(backgroundColor: PrimaryTheme.getColor(.primaryColor)) {
            navigation.navigationStack.append(OnboardingScreen.accountRegistration)
        }
        .padding()
        .accessibility(identifier: "getstarted")
    }
}
public var tinggColoredLogo: some View {
    PrimaryTheme.getImage(image: .tinggIcon)
        .resizable()
        .frame(width: 60, height: 60)
        .clipShape(Circle())
}
