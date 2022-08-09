//
//  SplashScreenWatcher.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import Foundation
public class EnvironmentUtils: ObservableObject {
    @Published public var state = SplashScreenState.start
    public init() {}
}
