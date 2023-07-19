//
//  BillsScreens.swift
//  
//
//  Created by Abdulrasaq on 04/07/2023.
//

import Foundation
import CoreNavigation
public enum BillsScreen: Screen {
    
    public static func == (lhs: BillsScreen, rhs: BillsScreen) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .billers(_):
            hasher.combine(0)
        case .fetchbillView(_):
            hasher.combine(1)
        case .billDetailsView(_, _):
            hasher.combine(2)
        case .nominationDetails(_):
            hasher.combine(3)
        case .categoriesAndServices(_):
            hasher.combine(4)
        case .transactionListView(_):
            hasher.combine(5)
        }
    }

    case billers(Any)
    case fetchbillView(Any)
    case billDetailsView(Any, Any)
    case nominationDetails(Any)
    case categoriesAndServices([Any])
    case transactionListView(Any)

}
