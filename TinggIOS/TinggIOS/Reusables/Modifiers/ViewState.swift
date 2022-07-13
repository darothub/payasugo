//
//  ErrorView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//

import Foundation
import SwiftUI
struct ViewState: ViewModifier {
    @Binding var isLoading: Bool
    @Binding var message: String
    init(isLoading: Binding<Bool>, message: Binding<String>) {
        _isLoading = isLoading
        _message = message
    }
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
            }
            if !message.isEmpty {
                ZStack {
                    Text(message)
                        .padding(.vertical, 5)
                        .foregroundColor(.red) // Would be refactor in the future for success message display
                }
            }
        }
    }
}
