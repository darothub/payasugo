//
//  HomeScreen.swift
//  
//
//  Created by Abdulrasaq on 27/04/2023.
//

import Foundation
enum HomeScreen: Hashable, Equatable {
    static func == (lhs: HomeScreen, rhs: HomeScreen) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .profile:
            hasher.combine(1)
        case .paymentOptions:
            hasher.combine(2)
        case .settings:
            hasher.combine(3)
        case .about:
            hasher.combine(4)
        case .support:
            hasher.combine(5)
        case .none:
            hasher.combine(6)
        case .categoriesAndServices(_):
            hasher.combine(7)
        }
    }
    case profile, paymentOptions, settings, about, support, none
    case categoriesAndServices([Any])
}
