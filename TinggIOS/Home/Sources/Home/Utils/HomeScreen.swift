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
        case .billers(_):
            hasher.combine(8)
        case .billFormView(_):
            hasher.combine(9)
        case .billDetailsView(_, _):
            hasher.combine(10)
        case .nominationDetails(_, _):
            hasher.combine(11)

        }
    }
    case profile, paymentOptions, settings, about, support, none
    case categoriesAndServices([Any])
    case billers(Any)
    case billFormView(Any)
    case billDetailsView(Any, Any)
    case nominationDetails(Any, Any)

}
