//
//  TingIOSApp.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//

import SwiftUI

@main
struct TinggIOSApp: App {
    @StateObject var enviromentUtils = EnvironmentUtils()
    var body: some Scene {
        WindowGroup {
            ZStack {
                IntroView()
                if enviromentUtils.state != .finish {
                    LaunchScreenView()
                }
            }.environmentObject(enviromentUtils)
        }
    }
}
