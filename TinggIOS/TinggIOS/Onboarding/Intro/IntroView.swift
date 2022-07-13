//
//  IntroView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import SwiftUI
import Theme
import Domain
struct IntroView: View {
    @EnvironmentObject var theme: EnvironmentUtils
    @State var active = false
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                topBackgroundDesign(size: geo.size)
                tinggColoredLogo
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
                        UtilViews.button(backgroundColor: theme.primaryTheme.primaryColor) {
                            active.toggle()
                        }
                    }
                }.task {
                    getCountries()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                setPageIndicatorAppearance()
            }
        }
    }
    func getCountries() {
        let fetch = FetchCountries()
        fetch.countriesCodesAndCountriesDialCodes()
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .environmentObject(EnvironmentUtils())
    }
}

extension IntroView {
    func setPageIndicatorAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
    }
    func topBackgroundDesign(size: CGSize) -> some View {
        BottomCurve()
            .fill(theme.primaryTheme.lightGray)
            .frame(width: size.width, height: size.height * 0.5)
            .edgesIgnoringSafeArea(.all)
    }

    var tinggColoredLogo: some View {
        Image("tinggicon")
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .shadow(radius: 3)
    }
}
