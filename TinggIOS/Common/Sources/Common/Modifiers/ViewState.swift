//
//  ErrorView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import SwiftUI
public struct ViewState: ViewModifier {
    @Binding var isLoading: Bool
    @Binding var message: String
    public init(isLoading: Binding<Bool>, message: Binding<String>) {
        _isLoading = isLoading
        _message = message
    }
    public func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
            }
            if !message.isEmpty && !message.contains("Su") {
                VStack {
                    Spacer()
                    Text(message)
                        .padding(.vertical, 5)
                        .foregroundColor(.red) // Would be refactor in the future for success message display
                }
            }
        }
    }
}
