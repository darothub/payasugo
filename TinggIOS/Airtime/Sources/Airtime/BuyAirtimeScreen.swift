//
//  BuyAirtimeScreen.swift
//  
//
//  Created by Abdulrasaq on 15/07/2023.
//

import Foundation
import CoreNavigation
public enum BuyAirtimeScreen: Screen, Equatable {
    case buyAirtime(String)
    public static func == (lhs: BuyAirtimeScreen, rhs: BuyAirtimeScreen) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
