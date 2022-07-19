//
//  SmallTextStyle.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//

import Foundation
import SwiftUI
import Theme
extension Text {
    func smallTextViewStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

struct SmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: PrimaryTheme.smallTextSize))
            .padding(PrimaryTheme.smallPadding)
            .multilineTextAlignment(.center)
    }
}
