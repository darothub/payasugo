//
//  ErrorView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import Combine
import SwiftUI


/// A view modifier to handle view state changes
public struct ViewStatesModifier: ViewModifier {
    @State var uiState: Published<UIModel>.Publisher
    @State var showAlert = false
    @State var message = ""
    @State private var showProgressBar = false
    @State private var cancellable: AnyCancellable?
    var action: () -> Void
    var onSuccess: (UIModel.Content) -> Void
    var onFailure: (String) -> Void
    public init(
        uiState: Published<UIModel>.Publisher,
        onSuccess: @escaping (UIModel.Content) -> Void,
        onFailure:  @escaping (String) -> Void = {str in },
        action: @escaping () -> Void = {}
    ) {
        self._uiState = State(initialValue: uiState)
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(showProgressBar)
                .onDisappear {
                    resetPublisher()
                    cancellable?.cancel()
                }
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .scaleEffect(2)
                .font(.caption)
                .showIf($showProgressBar)
        }
        .onAppear {
            cancellable = uiState.sink { us in
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
        }
     
        .alert(message, isPresented: $showAlert) {
            buttonEvent(action: action)
        }
    }
    private func resetPublisher() {
        let _ = uiState.output(at: 0)
    }
    fileprivate func buttonEvent(action:  @escaping () -> Void ) -> some View {
        return Button("OK") {
            action()
          
        }.accessibility(identifier: "alertbutton")
    }
}
/// A view modifier to handle view state changes
public struct UIState: ViewModifier {
    @Binding var uiState: UIModel
    @State var showAlert = false
    @State var message = ""
    @State private var showProgressBar = false
    @State var showAlertOnError: Bool = true
    @State var showAlertOnSuccess: Bool = false
    var action: () -> Void
    var onSuccess: (UIModel.Content) -> Void
    var onFailure: (String) -> Void
    public init(
        uiState:  Binding<UIModel>,
        showAlertOnError: Bool = true,
        showAlertOnSuccess: Bool = false,
        onSuccess: @escaping (UIModel.Content) -> Void,
        onFailure:  @escaping (String) -> Void = {str in },
        action: @escaping () -> Void = {}
    ) {
        self._uiState = uiState
        self._showAlertOnError = State(initialValue: showAlertOnError)
        self._showAlertOnSuccess = State(initialValue: showAlertOnSuccess)
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(showProgressBar)
 
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .scaleEffect(2)
                .font(.caption)
                .showIf($showProgressBar)
        }
        .onChange(of: uiState, perform: { us in
            switch us {
            case .error(let err):
                showAlert = showAlertOnError
                showProgressBar = false
                message = err
                onFailure(message)
                log(message: err)
//                uiState = UIModel.nothing
            case .content(let content):
                let cont = content
                showProgressBar = false
                showAlert = showAlertOnSuccess
                message = cont.statusMessage
                onSuccess(cont)
//                uiState = UIModel.nothing
            case .loading:
                showProgressBar = true
                log(message: "loading")
            case .nothing:
                showProgressBar = false
                log(message: "nothing")
          
            }
        })
        .alert(message, isPresented: $showAlert) {
            buttonEvent(action: action)
        }
        .onDisappear {
            uiState = UIModel.nothing
        }
    }
    fileprivate func buttonEvent(action:  @escaping () -> Void ) -> some View {
        return Button("OK") {
            action()
          
        }.accessibility(identifier: "alertbutton")
    }
}

/// A view modifier to handle view state changes
public struct ViewStatesModifierWithCustomShimmer: ViewModifier {
    let uiState: Published<UIModel>.Publisher
    @State var showAlert = false
    @State var message = ""
    @Binding var showProgressBar: Bool
    @State var showAlertOnError: Bool
    var shimmerView:  AnyView
    var action: () -> Void
    var onSuccess: (UIModel.Content) -> Void
    var onFailure: (String) -> Void
    public init(
        uiState: Published<UIModel>.Publisher,
        shimmerView:  AnyView,
        showProgressBar: Binding<Bool>,
        showAlertOnError: Bool = true,
        onSuccess: @escaping (UIModel.Content) -> Void,
        onFailure:  @escaping (String) -> Void = {str in },
        action: @escaping () -> Void = {}
    ) {
        self.uiState = uiState
        self.shimmerView = shimmerView
        self._showProgressBar = showProgressBar
        self._showAlertOnError = State(initialValue: showAlertOnError)
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
                showAlert = showAlertOnError
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
          
        }.accessibility(identifier: "alertbutton")
    }
}
public struct HorizontalBoxesShimmerView: View {
    public init () {
        //
    }
    public var body: some View {
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

extension View {
    public func handleViewStatesMods(
        uiState: Published<UIModel>.Publisher,
        onSuccess: @escaping (UIModel.Content) -> Void = {c in},
        onFailure:  @escaping (String) -> Void = {str in},
        action: @escaping () -> Void = {
            //TODO
        }
    ) -> some View {
        self.modifier(ViewStatesModifier(uiState: uiState, onSuccess: onSuccess, onFailure: onFailure, action: action))
    }
    public func handleUIState(
        uiState: Binding<UIModel>,
        showAlertonSuccess: Bool = false,
        showAlertonError: Bool = true,
        onSuccess: @escaping (UIModel.Content) -> Void = {c in},
        onFailure:  @escaping (String) -> Void = {str in},
        action: @escaping () -> Void = {
            //TODO
        }
    ) -> some View {
        self.modifier(
            UIState(
                uiState: uiState,
                showAlertOnError: showAlertonError,
                showAlertOnSuccess: showAlertonSuccess,
                onSuccess: onSuccess,
                onFailure: onFailure,
                action: action
            )
        )
    }
    public func handleViewStatesModWithCustomShimmer(
        uiState: Published<UIModel>.Publisher,
        showAlertOnError: Bool = true,
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
                showAlertOnError: showAlertOnError,
                onSuccess: onSuccess,
                onFailure: onFailure,
                action: action
            )
        )
    }
}

