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
    var onSuccessAction: () -> Void
    var onErrorAction: () -> Void
    public init(uiModel: Binding<UIModel>, showAlert: Binding<Bool>, showSuccessAlert: Binding<Bool> = .constant(false), onSuccessAction: @escaping () -> Void = {
        //TODO
    }, onErrorAction: @escaping () -> Void = {
        //TODO
    }) {
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
                handleMessage(data.statusMessage, action: onSuccessAction)
            case .error(let err):
                handleMessage(err, action:  onErrorAction)
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
public struct ViewStatesModifier: ViewModifier {
    let uiState: Published<UIModel>.Publisher
    @State var showAlert = false
    @State var message = ""
    @State private var showProgressBar = false
    @State private var disableContent = false
    @State var useDefaultHeight = false
    var action: () -> Void
    var onSuccess: (UIModel.Content) -> Void
    var onFailure: (String) -> Void
    public init(
        uiState: Published<UIModel>.Publisher,
        useDefaultHeight: Bool = false,
        onSuccess: @escaping (UIModel.Content) -> Void,
        onFailure:  @escaping (String) -> Void = {str in },
        action: @escaping () -> Void = {}
    ) {
        self.uiState = uiState
        self._useDefaultHeight = State(initialValue: useDefaultHeight)
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(disableContent)
                .frame(maxHeight: (useDefaultHeight && showProgressBar) ? 100.0 : .infinity)
 
            ProgressView()
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
                disableContent = false
                onFailure(message)
                log(message: err)
            case .content(let content):
                let cont = content
                showProgressBar = false
                showAlert = content.showAlert
                message = cont.statusMessage
                onSuccess(cont)
                disableContent = false

            case .loading:
                disableContent = true
                showProgressBar = true
                log(message: "loading")
            case .nothing:
                disableContent = false
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
        useDefaultHeight: Bool = false,
        onSuccess: @escaping (UIModel.Content) -> Void = {c in},
        onFailure:  @escaping (String) -> Void = {str in},
        action: @escaping () -> Void = {
            //TODO
        }
    ) -> some View {
        self.modifier(ViewStatesModifier(uiState: uiState, useDefaultHeight: useDefaultHeight, onSuccess: onSuccess, onFailure: onFailure, action: action))
    }
    public func handleViewStatesModWithShimmer(
        uiState: Published<UIModel>.Publisher,
        useDefaultHeight: Bool = false,
        showLoader: Bool = true,
        onSuccess: @escaping (UIModel.Content) -> Void = {c in},
        onFailure:  @escaping (String) -> Void = {str in},
        action: @escaping () -> Void = {
            //TODO
        }
    ) -> some View {
        self.modifier(
            ViewStatesModifierWithShimmer(
                uiState: uiState,
                useDefaultHeight: useDefaultHeight,
                showLoader: showLoader,
                onSuccess: onSuccess,
                onFailure: onFailure,
                action: action
            )
        )
    }
    public func handleViewStatesModWithCustomShimmer(
        uiState: Published<UIModel>.Publisher,
        shimmerView:  AnyView,
        isLoading: Binding<Bool> = .constant(false),
        onSuccess: @escaping (UIModel.Content) -> Void = {c in},
        onFailure:  @escaping (String) -> Void = {str in},
        action: @escaping () -> Void = {
            //TODO
        }
    ) -> some View {
        self.modifier(
            ViewStatesModifierWithCustomShimmer(
                uiState: uiState,
                shimmerView: shimmerView,
                showProgressBar: isLoading,
                onSuccess: onSuccess,
                onFailure: onFailure,
                action: action
            )
        )
    }
}

/// A view modifier to handle view state changes
public struct ViewStatesModifierWithShimmer: ViewModifier {
    let uiState: Published<UIModel>.Publisher
    @State var showAlert = false
    @State var message = ""
    @State private var showProgressBar = false
    @State var useDefaultHeight = false
    @State var showLoader = true
    var action: () -> Void
    var onSuccess: (UIModel.Content) -> Void
    var onFailure: (String) -> Void
    public init(
        uiState: Published<UIModel>.Publisher,
        useDefaultHeight: Bool = false,
        showLoader: Bool = true,
        onSuccess: @escaping (UIModel.Content) -> Void,
        onFailure:  @escaping (String) -> Void = {str in },
        action: @escaping () -> Void = {}
    ) {
        self.uiState = uiState
        self._useDefaultHeight = State(initialValue: useDefaultHeight)
        self._showLoader = State(initialValue: showLoader)
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(showProgressBar)
                .frame(maxHeight: (useDefaultHeight && showProgressBar) ? 100.0 : .infinity)
                .showIfNot($showProgressBar)
              
            ShimmerView()
                .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
                .showIf($showProgressBar)
                .showIf($showLoader)
               
        }
        .onReceive(uiState) { us in
            switch us {
            case .error(let err):
                showAlert = true
                showProgressBar = false
                message = err
                onFailure(message)
                log(message: err)
            case .content(let content):
                let cont = content
                showProgressBar = false
                showAlert = content.showAlert
                message = cont.statusMessage
                onSuccess(cont)

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
/// A view modifier to handle view state changes
public struct ViewStatesModifierWithCustomShimmer: ViewModifier {
    let uiState: Published<UIModel>.Publisher
    @State var showAlert = false
    @State var message = ""
    @Binding var showProgressBar: Bool
    var shimmerView:  AnyView
    var action: () -> Void
    var onSuccess: (UIModel.Content) -> Void
    var onFailure: (String) -> Void
    public init(
        uiState: Published<UIModel>.Publisher,
        shimmerView:  AnyView,
        showProgressBar: Binding<Bool>,
        onSuccess: @escaping (UIModel.Content) -> Void,
        onFailure:  @escaping (String) -> Void = {str in },
        action: @escaping () -> Void = {}
    ) {
        self.uiState = uiState
        self.shimmerView = shimmerView
        self._showProgressBar = showProgressBar
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(showProgressBar)
                .showIfNot($showProgressBar)
              
            shimmerView
                .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
                .showIf($showProgressBar)
               
        }
        .onReceive(uiState) { us in
            switch us {
            case .error(let err):
                showAlert = true
                showProgressBar = false
                message = err
                onFailure(message)
                log(message: err)
            case .content(let content):
                let cont = content
                showProgressBar = false
                showAlert = content.showAlert
                message = cont.statusMessage
                onSuccess(cont)

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
struct ShimmerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Color.gray
                .frame(width: 100, height: 5)
            Color.gray
                .frame(width: 70, height: 1)
            
            HStack(spacing: 20) {
                ForEach(0..<5, id: \.self) { service in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 50, height: 50)
                        
                }
            }


        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)

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


