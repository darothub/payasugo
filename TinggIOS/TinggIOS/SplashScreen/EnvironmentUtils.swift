//
//  EnvironmentUtils.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/10/2022.
//

import Foundation
public class EnvironmentUtils: ObservableObject {
    @Published var state = SplashScreenState.start
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
}
