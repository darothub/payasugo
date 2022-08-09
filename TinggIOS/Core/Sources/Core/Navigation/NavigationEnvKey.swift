//
//  File.swift
//  
//
//  Created by Abdulrasaq on 29/07/2022.
//

import Foundation
import SwiftUI
private struct NavigationEnvKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    public var modularNavigation: Binding<Bool> {
        get { self[NavigationEnvKey.self]}
        set { self[NavigationEnvKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    public func isModularNavigation(_ modularNavigation: Binding<Bool>) -> some View {
        environment(\.modularNavigation, modularNavigation)
    }
}
