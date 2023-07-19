//
//  HomeScreen.swift
//  
//
//  Created by Abdulrasaq on 27/04/2023.
//
import CoreNavigation
import Foundation
import CoreUI
enum HomeScreen: Screen {
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
        case .intro:
            hasher.combine(6)
        case .home(_, _):
            hasher.combine(7)
        case .pinCreationView:
            hasher.combine(8)
        case .securityQuestionView:
            hasher.combine(9)
        case .cardDetailsView(_, _):
            hasher.combine(10)
        case .cardWebView(_):
            hasher.combine(11)
        case .billView(_):
            hasher.combine(12)
        case .categoriesAndServices(_):
            hasher.combine(13)
        }
    }
    case profile, paymentOptions, settings, about, support
    case intro,
         home(String, Tab),
         pinCreationView,
         securityQuestionView,
         cardDetailsView(Any?, Any?),
         cardWebView(String),
         billView(String),
         categoriesAndServices([Any])

}
