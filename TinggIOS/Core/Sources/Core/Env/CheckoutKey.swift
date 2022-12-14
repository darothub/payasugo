//
//  File.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//

import Foundation
import Foundation
import SwiftUI

public struct CheckoutKey: EnvironmentKey {
    public static let defaultValue: Checkout = .init()
}

public extension EnvironmentValues {
    var checkout: Checkout {
        get { self[CheckoutKey.self] }
        set { self[CheckoutKey.self] = newValue }
    }
}

extension View {
    public func checkout(_ checkout: Checkout) -> some View {
        environment(\.checkout, checkout)
    }
}
