//
//  SplashScreenWatcher.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import Foundation
import Theme
class EnvironmentUtils: ObservableObject {
    @Published var state = SplashScreenState.start
    let primaryTheme = PrimaryTheme()
}
