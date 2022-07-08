//
//  OtpConfirmationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 08/07/2022.
//

import SwiftUI
import Theme

struct OtpConfirmationView: View {
    @State var otpSize = 4
    @State var otp = ""
    var theme: PrimaryTheme = .init()
    var body: some View {
        VStack {
            OtpFieldView(fieldSize: $otpSize, otpValue: $otp)
            UtilViews.button(backgroundColor: theme.primaryColor, buttonLabel: "Confirm") {
                print("Otp \(otp)")
            }
        }
    }
}

struct OtpConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        OtpConfirmationView()
    }
}
