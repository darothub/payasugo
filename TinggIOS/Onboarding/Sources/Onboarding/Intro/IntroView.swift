//
//  IntroView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//
import Core
import SwiftUI
import Theme
public struct IntroView: View {
    @State var active = false
    @StateObject var onboardingViewModel: OnboardingViewModel = .init(tinggApiServices: BaseRepository())
    @EnvironmentObject var navigation: NavigationUtils
    public init() {}
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                topBackgroundDesign(
                    height: geo.size.height * 0.5,
                    color: PrimaryTheme.getColor(.cellulantLightGray)
                )
                tinggColoredLogo
                IntroTabView(geo: geo, active: $active)
                    .environmentObject(navigation)
            }
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

struct IntroTabView: View {
    var geo: GeometryProxy
    @Binding var active: Bool
    @EnvironmentObject var navigation: NavigationUtils
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
            button(backgroundColor: PrimaryTheme.getColor(.primaryColor)) {
                navigation.rooms = .phone
            }
        }
    }
}
public var tinggColoredLogo: some View {
    PrimaryTheme.getImage(image: .tinggIcon)
        .resizable()
        .frame(width: 60, height: 60)
        .clipShape(Circle())
        .shadow(radius: 3)
}
