//
//  ErrorView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import Combine
import SwiftUI

@available(swift, deprecated: 5.0 , message: "This has been deprecated in build 6.0 v0.1.0 use ViewStates instead")
public struct ViewState: ViewModifier {
    @Binding var uiModel: UIModel
    @State var showAlert = false
    @State var error = ""

    @State var duplicateMessage = "empty"
    public init(uiModel: Binding<UIModel>) {
        _uiModel = uiModel
    }
    fileprivate func buttonEvent() -> some View {
       
        return Button("OK") {
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
                    handleMessage(message)
                }
            case .error(let err):
                handleMessage(err)
            case .nothing:
                content
            }
        }
    }
    fileprivate func handleMessage(_ message: String) -> some View {
        return VStack {
            // Intentionally unimplemented...placeholder view
        }
        .task {
           showAlert = true
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(0.6)

        .alert(error, isPresented: $showAlert) {
            buttonEvent()
        }
    }
}


/// A view modifier to handle view state changes
public struct ViewStates: ViewModifier {
    @Binding var uiModel: UIModel
    @Binding var showAlert: Bool
    @State var error = ""
    @State var errorFlag = false
    public init(uiModel: Binding<UIModel>, showAlert: Binding<Bool>) {
        _uiModel = uiModel
        _showAlert = showAlert
    }
    fileprivate func buttonEvent() -> some View {
       
        return Button("OK") {
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
                    handleMessage(message)
                }
            case .error(let err):
                handleMessage(err)
                content
                    .showIf($showAlert)
            case .nothing:
                content
            }
        }
    }
    fileprivate func handleMessage(_ message: String) -> some View {
        return VStack {
            // Intentionally unimplemented...placeholder view
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(0.6)
        .alert(message, isPresented: $showAlert) {
            buttonEvent()
        }
    }
}
