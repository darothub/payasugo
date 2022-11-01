//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 12/08/2022.
//

import SwiftUI

/// Custom OTF field view
public struct OtpFieldView: View {
    @Binding public var fieldSize: Int
    @Binding public var otpValue: String
    public var focusColor: Color
    @State fileprivate var fields = Array(repeating: "", count: 4)
    @FocusState fileprivate var cursor: Int?
    /// ``OtpFieldView`` initialiser
    /// - Parameters:
    ///   - fieldSize: number of OTP field
    ///   - otpValue: Binded OTP value
    ///   - focusColor: Color of focused OTP field
    public init(fieldSize: Binding<Int>, otpValue: Binding<String>, focusColor: Color) {
        self._fieldSize = fieldSize
        self._otpValue = otpValue
        self.focusColor = focusColor
        fields = Array(repeating: "", count: self.fieldSize)
    }
    public var body: some View {
        otpField()
    }
    fileprivate func otpfields(_ index: Int) -> some View {
        return VStack(spacing: 8) {
            TextField("", text: $fields[index])
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .multilineTextAlignment(.center)
                .focused($cursor, equals: index)
                .textContentType(.oneTimeCode)
            Rectangle()
                .fill(cursor == index ? focusColor : .gray.opacity(3))
                .frame(height: 3)
        }
    }
    fileprivate func eachField(_ index: Int) -> some View {
        return otpfields(index)
            .onChange(of: fields[index]) { newValue in
                cursorMovement(value: newValue, index: index)
                otpValue = fields.joined()
            }
            .frame(width: 40)
    }
    
    @ViewBuilder
    fileprivate func otpField() -> some View {
        HStack(spacing: 14) {
            ForEach(0..<fieldSize, id: \.self) { index in
                eachField(index)
            }
        }
    }
    fileprivate func cursorMovement(value: String, index: Int) {
        if value.count > 1 {
            fields[index] = String(value.last!)
        }
        if value.isEmpty && index != 0 {
            cursor = index - 1
        }
        if cursor == fields.count - 1 {
            cursor = nil
        }
        if !value.isEmpty && cursor != nil {
            cursor = index + 1
        }
    }
}

struct OtpFieldView_Previews: PreviewProvider {
    struct OtpFieldViewHolder: View {
        @State var fieldSize = 4
        @State var otp = ""
        var focusColor: Color = .green
        var body: some View {
            OtpFieldView(fieldSize: $fieldSize, otpValue: $otp, focusColor: focusColor)
        }
    }
    static var previews: some View {
        OtpFieldViewHolder()
    }
}
