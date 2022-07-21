//
//  IntroView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//
import Common
import Domain
import SwiftUI
import Theme
public struct IntroView: View {
    @State var active = false
    @StateObject var onboardingViewModel: OnboardingViewModel = .init(tinggApiServices: BaseRepository())
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                topBackgroundDesign(
                    height: geo.size.height * 0.5,
                    color: PrimaryTheme.getColor(.cellulantLightGray)
                )
                tinggColoredLogo
                IntroTabView(geo: geo, active: $active)
                    .task {
                        onboardingViewModel.allCountries()
                    }
            }
            .navigationBarHidden(true)
            .onAppear {
                setPageIndicatorAppearance()
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}

struct IntroTabView: View {
    var geo: GeometryProxy
    @Binding var active: Bool
    var body: some View {
        VStack {
            TabView {
                ForEach(onboardingItems(), id: \.info) { item in
                    VStack {
                        OnboadingView(onboadingItem: item, screenSize: geo.size)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            Spacer()
            NavigationLink(destination: PhoneNumberValidationView(), isActive: $active) {
                button(backgroundColor: PrimaryTheme.getColor(.primaryColor)) {
                    active.toggle()
                }
            }
        }
    }
}
