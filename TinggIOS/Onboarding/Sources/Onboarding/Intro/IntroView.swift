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

/// Introduces the onboarding screens to the user
public struct IntroView: View {
    @State private var active = false
    @EnvironmentObject var navigation: NavigationUtils
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                topBackgroundDesign(
                    height: geo.size.height * 0.5,
                    color: PrimaryTheme.getColor(.cellulantLightGray)
                )
                tinggColoredLogo
                    .accessibility(identifier: "tingggreenlogo")
                IntroTabView(geo: geo, active: $active)
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
    }
}

/// Tabview displays the onboarding views in turn
struct IntroTabView: View {
    var geo: GeometryProxy
    @Binding var active: Bool
    @EnvironmentObject var navigation: NavigationUtils
    var body: some View {
        VStack {
            TabView {
                onboardingViewListView()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .accessibility(identifier: "onboardingtabview")
            Spacer()
            NavigationLink(
                destination: PhoneNumberValidationView()
                    .environmentObject(navigation),
                isActive: $active
            ) {
                getStartedButton()
            }
        }
    }
    @ViewBuilder
    /// Iterates over available onboarding screens
    /// - Returns: OnboardingView
    fileprivate func onboardingViewListView() -> some View {
        ForEach(onboardingItems(), id: \.info) { item in
            VStack {
                OnboadingView(onboadingItem: item, screenSize: geo.size)
            }
        }
    }
    @ViewBuilder
    /// A button with `Get started` text
    /// - Returns: Button
    fileprivate func getStartedButton() -> some View {
        TinggButton(backgroundColor: PrimaryTheme.getColor(.primaryColor)) {
            active.toggle()
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
        .shadow(radius: 3)
}
