//
//  File.swift
//  
//
//  Created by Abdulrasaq on 13/05/2023.
//

import Foundation
import SwiftUI

public struct CustomOTPView: UIViewRepresentable {
    let placeholder: String // text field placeholder
    @Binding var text: String // input binding
    @FocusState var isFocusedIndex: Int?
    var index = 0
    let onBackspace: (Bool) -> Void // true if backspace on empty input
    
    public func makeCoordinator() -> CustomOTPTextFieldCoordinator {
        CustomOTPTextFieldCoordinator(textBinding: $text)
    }

    public func makeUIView(context: Context) -> CustomOTPUITextField {
        let view = CustomOTPUITextField()
        view.placeholder = placeholder
        view.delegate = context.coordinator
        view.keyboardType = .numberPad
        view.textContentType = .oneTimeCode
        view.textAlignment = .center
        view.textColor = UIColor.black
        return view
    }

    public func updateUIView(_ uiView: CustomOTPUITextField, context: Context) {
        uiView.text = text
        uiView.onBackspace = onBackspace
        if isFocusedIndex == index {
            uiView.becomeFirstResponder()
        }
    }

  // custom UITextField subclass that detects backspace events
    public class CustomOTPUITextField: UITextField {
        public var onBackspace: ((Bool) -> Void)?

        override init(frame: CGRect) {
            onBackspace = nil
            super.init(frame: frame)
        }

        required init?(coder: NSCoder) {
            fatalError()
        }

        public override func deleteBackward() {
            onBackspace?(text?.isEmpty == true)
            super.deleteBackward()
        }
  }
}

// the coordinator is here to allow for mapping text to the
// binding using the delegate methods
public class CustomOTPTextFieldCoordinator: NSObject {
  let textBinding: Binding<String>

  public init(textBinding: Binding<String>) {
    self.textBinding = textBinding
  }
}

extension CustomOTPTextFieldCoordinator: UITextFieldDelegate {
    public func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
        textBinding.wrappedValue = textField.text ?? ""
        return true
    }
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.textBinding.wrappedValue = textField.text ?? ""
        }
    }
}
