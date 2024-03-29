//
//  SmallTextStyle.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//

import SwiftUI
public extension Text {
    func smallTextViewStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

public struct SmallTextStyle: ViewModifier {
    public init() {
        // Intentionally unimplemented...needed for modular accessibility
    }
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 12))
            .padding(12)
            .multilineTextAlignment(.center)
    }
}
