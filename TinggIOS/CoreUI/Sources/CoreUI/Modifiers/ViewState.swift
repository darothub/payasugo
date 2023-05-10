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

@available(swift, deprecated: 5.0 , message: "This has been deprecated in build 14.0 v0.1.0 use ViewStatesMod instead")
/// A view modifier to handle view state changes
public struct ViewStates: ViewModifier {
    @Binding var uiModel: UIModel
    @Binding var showAlert: Bool
    @Binding var showSuccessAlert: Bool
    @State var disableContent = false
    @State var show = false
    public static var alertButtonText = "alertbutton"
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
          
        }.accessibility(identifier: ViewStates.alertButtonText)
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
                HandleMessageView(message: data.statusMessage, showAlert: $showAlert, showSuccessAlert: $showSuccessAlert, onSuccessAction: onSuccessAction)
//                handleMessage(data.statusMessage, action: onSuccessAction)
            case .error(let err):
                HandleMessageView(message: err, showAlert: $showAlert, showSuccessAlert: $showSuccessAlert, onErrorAction: onErrorAction)
//                handleMessage(err, action:  onErrorAction)
            case .nothing:
                EmptyView()
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
/// A view modifier to handle view state changes
public struct ViewStatesMod: ViewModifier {
    let uiState: Published<UIModel>.Publisher
    @State var subscriptions = Set<AnyCancellable>()
    @State var showProgressBar = false
    @State var showAlert = false
    @State var message = ""
    var action: () -> Void = {}
    var onSuccess: (UIModel.Content) -> Void
    public init(uiState: Published<UIModel>.Publisher, onSuccess: @escaping (UIModel.Content) -> Void, action: @escaping () -> Void = {}) {
        self.uiState = uiState
        self.onSuccess = onSuccess
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .scaleEffect(2)
                .font(.caption)
                .showIf($showProgressBar)
        }
        .onReceive(uiState) { us in
            switch us {
            case .error(let err):
                showAlert = true
                showProgressBar = false
                message = err
                log(message: err)
            case .content(let content):
                let cont = content
                showProgressBar = false
                showAlert = content.showAlert
                message = cont.statusMessage
                onSuccess(cont)
                log(message: cont)
            case .loading:
                showProgressBar = true
                log(message: "loading")
            case .nothing:
                showProgressBar = false
                log(message: "nothing")
            }
        }
        .alert(message, isPresented: $showAlert) {
            buttonEvent(action: action)
        }
    }
    fileprivate func buttonEvent(action:  @escaping () -> Void ) -> some View {
        return Button("OK") {
            action()
          
        }.accessibility(identifier: ViewStates.alertButtonText)
    }
}
extension View {
    public func handleViewStatesMods(
        uiState: Published<UIModel>.Publisher,
        onSuccess: @escaping (UIModel.Content) -> Void,
        action: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(ViewStatesMod(uiState: uiState, onSuccess: onSuccess, action: action))
    }
}
extension ViewModifier {
    public func throwError(message: String) -> Never {
        return fatalError("\(Self.self) -> \(message)")
    }
    public func log(message: String) {
        print("\(Self.self) -> \(message)")
    }
    public func log(message: Any) {
        print("\(Self.self) -> \(message)")
    }
}

struct HandleMessageView: View {
    @State var message: String
    @Binding var showAlert: Bool
    @Binding var showSuccessAlert: Bool
    var onSuccessAction: () -> Void = {}
    var onErrorAction: () -> Void = {}
    var body: some View {
        VStack {
            // ....
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(0.6)
        .alert(message, isPresented: $showSuccessAlert) {
            return Button("OK") {
                // Intentionally unimplemented...no action needed
                onSuccessAction()
              
            }.accessibility(identifier: ViewStates.alertButtonText)
        }
        .alert(message, isPresented: $showAlert) {
            return Button("OK") {
                // Intentionally unimplemented...no action needed
                onErrorAction()
              
            }.accessibility(identifier: ViewStates.alertButtonText)
        }
    }
}

