//
//  CustomDialog.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//

import Foundation
import SwiftUI
struct CustomDialog<DialogContent: View>: ViewModifier {
  @Binding var isPresented: Bool // set this to show/hide the dialog
  let dialogContent: DialogContent

  init(isPresented: Binding<Bool>, @ViewBuilder dialogContent: () -> DialogContent) {
    _isPresented = isPresented
     self.dialogContent = dialogContent()
  }

  func body(content: Content) -> some View {
   // wrap the view being modified in a ZStack and render dialog on top of it
    ZStack {
      content
      if isPresented {
        // the semi-transparent overlay
        Rectangle().foregroundColor(Color.black.opacity(0.6))
        // the dialog content is in a ZStack to pad it from the edges
        // of the screen
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
