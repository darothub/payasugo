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
    @State var modulaNavigation = false
    @State var fieldSize = 4
    @State var otp = ""
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    NavigationLink(destination: destination, isActive: $navigation.navigatePermission){
                        ViewHouse()
                            .environmentObject(navigation)
                    }
                    if navigation.rooms != .launch {
                        LaunchScreenView()
                            .environmentObject(navigation)
                    }
                }                
            }
        }
    }
    @ViewBuilder
    var destination: some View {
        switch navigation.rooms {
        case .phone:
            PhoneNumberValidationView()
                .environmentObject(navigation)
                .navigationBarHidden(false)
        case .home:
            HomeBottomNavView()
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
