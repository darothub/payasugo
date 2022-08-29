//
//  ErrorView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//

import SwiftUI

public struct ViewState: ViewModifier {
    @Binding var uiModel: UIModel
    @State var showAlert = false
    @State var error = ""
    public init(uiModel: Binding<UIModel>) {
        _uiModel = uiModel
    }
    fileprivate func buttonEvent() -> some View {
        return Button("OK", role: .cancel) {
            // Intentionally unimplemented...no action needed
        }
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            switch uiModel {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2)
            case .content(let data):
                let message = data.statusMessage.lowercased().contains("succ") ? "" : data.statusMessage
                if !message.isEmpty {
                    VStack {
                        // Intentionally unimplemented...placeholder view
                    }
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0)
                        .onAppear {
                            showAlert.toggle()
                        }
                    .alert(message, isPresented: $showAlert) {
                        buttonEvent()
                    }
                }
            case .error(let err):
                VStack {
                    // Intentionally unimplemented...placeholder view
                }
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0)
                    .onAppear {
                        showAlert.toggle()
                    }
                .alert(err, isPresented: $showAlert) {
                    buttonEvent()
                }
            case .nothing:
                content
            }
        }
    }
}
