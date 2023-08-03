//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 12/08/2022.
//

import SwiftUI
import Combine

/// Custom OTF field view
public struct PINTextFieldView: View {
    public var fieldSize: Int
    public var focusColor: Color
    @Binding public var otpValue: String
    @State fileprivate var fields = Array(repeating: "", count: 4)
    @FocusState fileprivate var cursor: Int?
    @State var toHaveBorder = false
    @FocusState var focus: Int?
    var onCompleteListener: OnPINTextFieldListener?
    /// ``OtpFieldView`` initialiser
    /// - Parameters:
    ///   - fieldSize: number of OTP field
    ///   - otpValue: Binded OTP value
    ///   - focusColor: Color of focused OTP field
    public init(fieldSize: Int = 4, otpValue: Binding<String>, focusColor: Color, toHaveBorder: Bool = false, onCompleteListener: OnPINTextFieldListener? = nil) {
        self.fieldSize = fieldSize
        self._otpValue = otpValue
        self.focusColor = focusColor
        self._toHaveBorder = State(initialValue: toHaveBorder)
        self.onCompleteListener = onCompleteListener
        fields = Array(repeating: "", count: self.fieldSize)
    }
    public var body: some View {
        otpField()
    }
    fileprivate func otpfields(_ index: Int) -> some View {
        return VStack(spacing: 8) {
            CustomOTPView(placeholder: "", text: $fields[index], isFocusedIndex: _cursor, index: index) { onEmpty in
                if onEmpty && focus != 0 {
                    focus = index - 1
                }
             }
            .frame(maxWidth: .infinity, maxHeight: 30)
            .focused($focus, equals: index)
            .multilineTextAlignment(.center)
            .padding(5)
            .onTapGesture {
                focus = index
            }
            Rectangle()
                .fill(focus == index ? focusColor : .gray.opacity(3))
                .frame(height: 3)
        }.background(
            toHaveBorder ?
            RoundedRectangle(cornerRadius: 2)
                .stroke()
            : RoundedRectangle(cornerRadius: 0)
                .stroke(lineWidth: 0.0)
                
        )
        .onAppear {
            focus = 0
        }
      
    }
    @ViewBuilder
    fileprivate func otpField() -> some View {
        HStack(spacing: 14) {
            ForEach(0..<fieldSize, id: \.self) { index in
                eachField(index)
            }
        }
    }
    fileprivate func eachField(_ index: Int) -> some View {
        return otpfields(index)
            .onChange(of: fields[index]) { newValue in
                cursorMovement(value: newValue, index: index)
                otpValue = fields.joined()
                if onCompleteListener != nil  && index == fieldSize-1 && !newValue.isEmpty {
                    onCompleteListener?.onFinishInput(otpValue)
                }
            }
            .frame(width: 40)
    }
    fileprivate func cursorMovement(value: String, index: Int) {
        if value.count > 0 {
            fields[index] = String(value.prefix(1))
        }
        if value.count < 1 && index > 0 {
            focus = index - 1
        }
        if value.isEmpty && index != 0 {
            focus = index - 1
        }
        if !value.isEmpty && index != fields.count - 1 {
            focus = index + 1
        }
        if !value.isEmpty && index == fieldSize-1 {
            focus = nil
        }
    }
}

struct OtpFieldView_Previews: PreviewProvider {
    struct OtpFieldViewHolder: View {
        @State var fieldSize = 4
        @State var otp = ""
        var focusColor: Color = .green
        var body: some View {
            PINTextFieldView(fieldSize: fieldSize, otpValue: $otp, focusColor: focusColor)
        }
    }
    static var previews: some View {
        OtpFieldViewHolder()
    }
}

public protocol OnPINTextFieldListener {
    func onFinishInput(_ otp: String) -> Void
}

