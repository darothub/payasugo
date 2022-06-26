//
//  IntroView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import SwiftUI
import Theme
struct IntroView: View {
    @EnvironmentObject var themes: EnvironmentUtils
    var theme = PrimaryTheme()
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
                                Spacer()
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    Spacer()
                    NavigationLink(destination: PhoneNumberValidationView(), isActive: $active) {
                        UtilViews.button(backgroundColor: theme.primaryColor) {
                            active.toggle()
                            print("Continue")
                        }
                    }
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
            .fill(theme.lightGray)
            .frame(width: size.width, height: size.height * 0.5)
            .edgesIgnoringSafeArea(.all)
    }

    var tinggColoredLogo: some View {
        Image("tinggcoloredicon")
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .shadow(radius: 3)
    }
}
