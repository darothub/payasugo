//
//  File.swift
//  
//
//  Created by Abdulrasaq on 17/10/2022.
//

import Foundation
public enum Screens: Hashable {
    public static func == (lhs: Screens, rhs: Screens) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .intro:
            hasher.combine(1)
        case .home:
            hasher.combine(2)
        case .buyAirtime(_):
            hasher.combine(3)
        case .billers(_):
            hasher.combine(4)
        case .categoriesAndServices(_):
            hasher.combine(5)
        case .billFormView(_):
            hasher.combine(6)
        case .billDetailsView(_, _):
            hasher.combine(7)
        case .nominationDetails(_, _):
            hasher.combine(8)
        case .pinCreationView:
            hasher.combine(9)
        case .securityQuestionView:
            hasher.combine(10)
        case .cardDetailsView(_, _):
            hasher.combine(11)
        case .cardWebView(let value):
            hasher.combine(value)
        case .lost:
            hasher.combine(0)
        case .transactionListView(_):
            hasher.combine(12)
        }
    }
    case intro,
         home,
         buyAirtime(String),
         billers(Any),
         categoriesAndServices([Any]),
         billFormView(Any),
         billDetailsView(Any, Any),
         nominationDetails(Any, Any),
         pinCreationView,
         securityQuestionView,
         cardDetailsView(Any?, Any?),
         cardWebView(String),
         transactionListView(Any),
         lost
}




