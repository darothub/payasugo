//
//  CustomDialog.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//

import Foundation
import SwiftUI
/// Custom dialog
public struct CustomDialog<DialogContent: View>: ViewModifier {
    @Binding public var isPresented: Bool
    public let dialogContent: DialogContent
    /// ``CustomDialog``
    /// - Parameters:
    ///   - isPresented: Binded flag value for dialog presentation status
    ///   - dialogContent: content of dialog
  public init(isPresented: Binding<Bool>, @ViewBuilder dialogContent: () -> DialogContent) {
    _isPresented = isPresented
     self.dialogContent = dialogContent()
  }

  public func body(content: Content) -> some View {
    ZStack {
      content
      if isPresented {
        Rectangle().foregroundColor(Color.black.opacity(0.6))
        ZStack {
          dialogContent
            .background(
              RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
            )
        }.padding(40)
      }
    }
  }
}
