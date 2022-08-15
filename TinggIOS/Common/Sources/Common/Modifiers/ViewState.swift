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
    fileprivate func buttonEvent() -> Button<Text> {
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
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3)
            case .content(let data):
                let message = data.statusMessage.lowercased().contains("succ") ? "" : data.statusMessage
                VStack {
                    Text(message)
                        .padding(.vertical, 5)
                        .foregroundColor(
                            .red
                        )
                    Spacer()
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
                EmptyView()
            }
        }
    }
}