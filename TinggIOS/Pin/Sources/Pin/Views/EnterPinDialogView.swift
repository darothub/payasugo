//
//  PinDialogView.swift
//
//
//  Created by Abdulrasaq on 02/08/2023.
//
import Combine
import Core
import CoreUI
import SwiftUI
import Theme
import CoreNavigation
public struct EnterPinDialogView: View, OnPINTextFieldListener {
    @Environment(\.dismiss) var dismiss
    @StateObject var pinDialogVm = PinDialogViewModel()
    @State var pin: String = ""
    var listener: OnEnterPINListener?
    @EnvironmentObject var navigation: NavigationManager
    @State var next: String = ""
    @State var successful = false
    @State var showView = true
    public init(pin: String, next: String = "", listener: OnEnterPINListener? = nil) {
        _pin = State(initialValue: pin)
        _next = State(initialValue: next)
        self.listener = listener
    }

    public var body: some View {
        VStack {
            PINTextFieldView(fieldSize: 4, otpValue: $pin, focusColor: PrimaryTheme.getColor(.primaryColor), toHaveBorder: true, onCompleteListener: self)
                .padding()
            Text("Forgot pin?")
                .font(.caption)
        }
        .onAppear {
            guard let _: Base64String = AppStorageManager.mulaPin else {
                navigation.navigateTo(screen: PinScreen.pinView)              
                return
            }
        }
        .showIf($showView)
        .padding()
        .padding(.bottom)
        .handleViewStatesMods(uiState: pinDialogVm.$pinUIModel) { content in
            _ = content.data as! BaseDTO
            withAnimation {
                DispatchQueue.main.async {
                    listener?.onFinish(pin, next: next)
                }
            }
        }
    }

    public func onFinishInput(_ otp: String) {
        let isValidPin = pinDialogVm.validateLocalPin(pin: otp)
        if isValidPin {
            let request = RequestMap.Builder()
                .add(value: "VALIDATE", for: .ACTION)
                .add(value: "MPM", for: .SERVICE)
                .add(value: otp, for: "MULA_PIN")
                .build()
            pinDialogVm.validatePin(request: request)
        } else {
            pinDialogVm.pinUIModel = UIModel.error("Invalid pin")
        }
    }
}

#Preview {
    EnterPinDialogView(pin: "1234")
}

public protocol OnEnterPINListener {
    func onFinish(_ otp: String, next: String)
}

public struct EnterPINDialogModifier: ViewModifier {
    @Binding var showPinDialog: Bool
    @State var pin = ""
    @Binding var onFinish: String
    var listener: OnEnterPINListener?
    public init(showPinDialog: Binding<Bool> = .constant(false), pin: String = "", onFinish: Binding<String>, listener: OnEnterPINListener? = nil) {
        _showPinDialog = showPinDialog
        _pin = State(initialValue: pin)
        _onFinish = onFinish
        self.listener = listener
    }

    public func body(content: Content) -> some View {
        content
            .customDialog(isPresented: $showPinDialog, cancelOnTouchOutside: .constant(true)) {
                EnterPinDialogView(pin: pin, next: onFinish, listener: listener)
                    .onAppear(perform: {
                        guard let _: Base64String = AppStorageManager.mulaPin else {
                            showPinDialog = false
                            return
                        }
                    })
                    
            }
    }
}

@MainActor
public class PinDialogViewModel: ViewModel {
    @Published var pinUIModel = UIModel.nothing
    var tinggApiService: TinggApiServices = BaseRequest.shared
    public init () {
        //
    }
    public func validatePin(request: RequestMap) {
        pinUIModel = UIModel.loading
        Task {
            do {
                let result: BaseDTO = try await tinggApiService.result(request.encryptPayload()!)
                handleResultState(model: &pinUIModel, Result.success(result) as Result<Any, Error>, showAlertOnSuccess: false)
            } catch {
                handleResultState(model: &pinUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }
    func validateLocalPin(pin: String) -> Bool {
        guard  let mulapinBase64String: Base64String = AppStorageManager.mulaPin else {
            return false
        }
        guard mulapinBase64String.isNotEmpty, let pinDecoded = Data(base64Encoded: mulapinBase64String) else {
            return false
        }
        do {
            guard let mulaPin: String? = try TinggSecurity.simptleDecryption(pinDecoded) else {
                return false
            }
            return mulaPin == pin
            
        } catch {
            pinUIModel = UIModel.error(error.localizedDescription)
            return false
        }
    }

    /// Handle result
    public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>, showAlertOnSuccess: Bool = false) where E: Error {
        switch result {
        case let .failure(apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case let .success(data):
            var content: UIModel.Content
            if let d = data as? BaseDTOprotocol {
                content = UIModel.Content(data: data, statusMessage: d.statusMessage, showAlert: showAlertOnSuccess)
            } else {
                content = UIModel.Content(data: data, showAlert: showAlertOnSuccess)
            }
            model = UIModel.content(content)
            return
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(EnterPINDialogModifier(showPinDialog: .constant(false), onFinish: .constant("")))
}

public extension View {
    func attachEnterPinDialog(
        showPinDialog: Binding<Bool>,
        pin: String = "",
        onFinish: Binding<String>,
        listener: OnEnterPINListener?
    ) -> some View {
        modifier(EnterPINDialogModifier(showPinDialog: showPinDialog, pin: pin, onFinish: onFinish, listener: listener))
    }
}
