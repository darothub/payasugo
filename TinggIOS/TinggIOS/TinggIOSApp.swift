//
//  TingIOSApp.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//
import Onboarding
import SwiftUI

@main
struct TinggIOSApp: App {
    @StateObject var enviromentUtils = EnvironmentUtils()
    @State var fieldSize = 4
    @State var otp = ""
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    IntroView()
                        .onAppear {
                            UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                            print(FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path)
                        }
                    if enviromentUtils.state != .finish {
                        LaunchScreenView()
                    }
                }.environmentObject(enviromentUtils)
            }
        }
    }
}
