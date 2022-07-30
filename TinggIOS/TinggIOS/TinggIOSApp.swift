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
    @StateObject var hvm: HomeViewModel = .init()
    @State var profile: Profile = .init()
    @State var categories: [[Categorys]] = [[]]
    @State var quicktops: [MerchantService] = [MerchantService]()
    @State var fieldSize = 4
    @State var otp = ""
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    NavigationLink("", destination: destination, isActive: $navigation.navigatePermission)
                    if navigation.screen != .launch {
                        LaunchScreenView()
                            .environmentObject(navigation)
                    }
                }                
            }
        }
    }
    @ViewBuilder
    var destination: some View {
        switch navigation.screen {
        case .home:
            HomeBottomNavView(
                profile: $profile,
                categories: $categories,
                quickTopups: $quicktops
            ).onAppear {
                withAnimation {
                    profile = hvm.getProfile()
                    categories = hvm.processedCategories
                    quicktops = hvm.getQuickTopups()
                }
            }
        case .intro:
            IntroView()
                .navigationBarHidden(true)
                .environmentObject(navigation)
        case .launch:
            LaunchScreenView()
                .environmentObject(navigation)
        }
    }
}

