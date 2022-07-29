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
                    ViewHouse()
                        .environmentObject(navigation)
                        .isModularNavigation($modulaNavigation)
                        .onAppear {
                            print(FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path)
                        }
                    if enviromentUtils.state != .finish {
                        LaunchScreenView()
                    }
                }
                .environmentObject(enviromentUtils)
            }
        }
    }
}
