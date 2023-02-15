//
//  File.swift
//  
//
//  Created by Abdulrasaq on 26/01/2023.
//

import Foundation
import SwiftUI
public struct CreditCardDetailsKey: EnvironmentKey {
    public static let defaultValue: CardDetails = .init()
}

public extension EnvironmentValues {
    var cardDetails: CardDetails {
        get { self[CreditCardDetailsKey.self] }
        set { self[CreditCardDetailsKey.self] = newValue }
    }
}

extension View {
    public func setCardDetails(_ cardDetails: CardDetails) -> some View {
        environment(\.cardDetails, cardDetails)
    }
}
