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
    var theme: PrimaryTheme
    func body(content: Content) -> some View {
        content
            .font(.system(size: theme.smallTextSize))
            .padding(theme.smallPadding)
            .multilineTextAlignment(.center)
    }
}
