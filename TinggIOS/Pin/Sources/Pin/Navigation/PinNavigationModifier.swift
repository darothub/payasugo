//
//  PinNavigationModifier.swift
//  
//
//  Created by Abdulrasaq on 01/08/2023.
//


import Core
import CoreUI
import Foundation

import SwiftUI
public struct PinNavigationModifier: ViewModifier {
    @State var colorTint:Color = .blue
    public func body(content: Content) -> some View {
        content
            .changeTint($colorTint)
            .navigationDestination(for: PinScreen.self, destination: { screen in
                switch screen {
                case .securityQuestionView(let pin):
                    SecurityQuestionView(pin: pin)
                case .pinView:
                    EnterPinFullScreenView()
                }
            })
    }
}

extension View {
    public func pinNavigation() -> some View {
        modifier(PinNavigationModifier())
    }
}
