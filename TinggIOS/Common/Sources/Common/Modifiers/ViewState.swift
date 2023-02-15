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
    @Binding var showSuccessAlert: Bool
    @State var disableContent = false
    @State var show = false
    var onSuccessAction: () -> Void = {}
    var onErrorAction: () -> Void = {}
    public init(uiModel: Binding<UIModel>, showAlert: Binding<Bool>, showSuccessAlert: Binding<Bool> = .constant(false), onSuccessAction: @escaping () -> Void = {}, onErrorAction: @escaping () -> Void = {}) {
        _uiModel = uiModel
        _showAlert = showAlert
        _showSuccessAlert = showSuccessAlert
        self.onSuccessAction = onSuccessAction
        self.onErrorAction = onErrorAction
    }
    fileprivate func buttonEvent(action:  @escaping () -> Void ) -> some View {
       
        return Button("OK") {
            // Intentionally unimplemented...no action needed
            action()
          
        }
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            switch uiModel {
            case .loading:
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2)
                    .font(.caption)
            case .content(let data):
                handleMessage(data.statusMessage, action: onSuccessAction)
            case .error(let err):
                handleMessage(err, action:  onErrorAction)
            case .nothing:
                content
            }
        }
    }
    fileprivate func handleMessage(_ message: String, action:  @escaping () -> Void ) -> some View {
        print("AlertMessage \(message)")
        return VStack {
            // ....
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(0.6)
        .alert(message, isPresented: $showSuccessAlert) {
            buttonEvent(action: action)
        }
        .alert(message, isPresented: $showAlert) {
            buttonEvent(action: action)
        }

    }
}

