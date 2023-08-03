//
//  PinDialogView.swift
//
//
//  Created by Abdulrasaq on 02/08/2023.
//
import Theme
import CoreUI
import SwiftUI

public struct EnterPinDialogView: View, OnPINTextFieldListener {
    public func onFinishInput(_ otp: String) {
        if listener != nil {
            listener?.onFinish(otp, next: next)
        }
    }
    
    @State var pin: String = ""
    var listener: OnEnterPINListener?
    var next: String = ""
    public init(pin: String, next: String = "", listener: OnEnterPINListener? = nil) {
        self._pin = State(initialValue: pin)
        self.next = next
        self.listener = listener
    }
    public var body: some View {
        VStack {
            PINTextFieldView(fieldSize: 4, otpValue: $pin, focusColor: PrimaryTheme.getColor(.primaryColor), toHaveBorder: true, onCompleteListener: self)
                .padding()
            Text("Forgot pin?")
                .font(.caption)
        }
        .padding()
        .padding(.bottom)
    }
}

#Preview {
    EnterPinDialogView(pin: "1234")
}

public protocol OnEnterPINListener {
    func onFinish(_ otp: String, next: String)
}
