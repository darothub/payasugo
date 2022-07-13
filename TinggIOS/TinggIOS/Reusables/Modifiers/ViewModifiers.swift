//
//  ViewModifiers.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//

import Foundation
import SwiftUI
extension View {
    @ViewBuilder
    func someShadow(showShadow: Binding<Bool>) -> some View {
        shadow(color: showShadow.wrappedValue ? .green : .red, radius: 1)
    }
    @ViewBuilder
    func someForegroundColor(condition: Binding<Bool>) -> some View {
        shadow(color: condition.wrappedValue ? .green : .red, radius: 1)
    }
    func customDialog<DialogContent: View>(
      isPresented: Binding<Bool>,
      @ViewBuilder dialogContent: @escaping () -> DialogContent
    ) -> some View {
      self.modifier(CustomDialog(isPresented: isPresented, dialogContent: dialogContent))
    }
    func handleViewState(
      isLoading: Binding<Bool>,
      message: Binding<String>
    ) -> some View {
      self.modifier(ViewState(isLoading: isLoading, message: message))
    }
}
