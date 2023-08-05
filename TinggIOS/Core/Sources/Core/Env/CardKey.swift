//
//  File.swift
//  
//
//  Created by Abdulrasaq on 04/08/2023.
//

import Foundation

import SwiftUI
public struct CardKey: EnvironmentKey {
    public static let defaultValue: Card = .init()
}

public extension EnvironmentValues {
    var card: Card {
        get { self[CardKey.self] }
        set { self[CardKey.self] = newValue }
    }
}

extension View {
    public func setCard(_ card: Card) -> some View {
        environment(\.card, card)
    }
}



