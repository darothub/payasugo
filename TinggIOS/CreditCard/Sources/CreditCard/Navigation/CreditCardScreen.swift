//
//  CreditCardScreen.swift
//
//
//  Created by Abdulrasaq on 03/08/2023.
//
import CoreNavigation
import Foundation
public enum CreditCardScreen: Screen {
    public static func == (lhs: CreditCardScreen, rhs: CreditCardScreen) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
 
    public func hash(into hasher: inout Hasher) {
        switch self {
            
        case .enterCardDetailsScreen:
            hasher.combine(0)
        case .savedCardScreen:
            hasher.combine(1)
        case .activateCardScreen(_):
            hasher.combine(2)
        }
    }
    
    case enterCardDetailsScreen
    case savedCardScreen
    case activateCardScreen(Any)
}
