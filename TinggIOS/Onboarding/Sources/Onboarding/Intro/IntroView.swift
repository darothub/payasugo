//
//  IntroView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//
import Common
import Core
import SwiftUI
import Theme
public struct IntroView: View {
    @State var active = false
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
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
                    .environmentObject(onboardingViewModel)
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
            .environmentObject(OnboardingViewModel(
                countryRepository: CountryRepositoryImpl(
                    apiService: BaseRepository(),
                    realmManager: RealmManager()
                ),
                baseRequest: BaseRequest(apiServices: BaseRepository())
            )
        )
    }
}

struct IntroTabView: View {
    var geo: GeometryProxy
    @Binding var active: Bool
    @EnvironmentObject var navigation: NavigationUtils
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
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
                    .environmentObject(onboardingViewModel)
                    .environmentObject(navigation),
                isActive: $active
            ) {
                getStartedButton()
            }
        }
    }
    @ViewBuilder
    fileprivate func onboardingViewListView() -> some View {
        ForEach(onboardingItems(), id: \.info) { item in
            VStack {
                OnboadingView(onboadingItem: item, screenSize: geo.size)
            }
        }
    }
    @ViewBuilder
    fileprivate func getStartedButton() -> some View {
        button(backgroundColor: PrimaryTheme.getColor(.primaryColor)) {
            active.toggle()
        }
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
