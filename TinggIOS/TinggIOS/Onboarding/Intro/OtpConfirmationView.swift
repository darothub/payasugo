//
//  OtpConfirmationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 08/07/2022.
//
import ApiModule
import Core
import Domain
import SwiftUI
import Theme

struct OtpConfirmationView: View {
    @State var otpSize = 4
    @State var otp = ""
    @State var timeLeft = 60
    @State var timeAdvice = ""
    @Binding var activeCountry: Country
    @Binding var phoneNumber: String
    @StateObject var confirmActivationCode: ConfirmActivationCode = .init()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var theme: PrimaryTheme = .init()
    var body: some View {
        VStack {
            Text("Confirm OTP")
                .fontWeight(.bold)
            Divider()
            OtpFieldView(fieldSize: $otpSize, otpValue: $otp)
                .padding(.vertical, 20)
            Text(timeAdvice)
            UtilViews.button(backgroundColor: theme.primaryColor, buttonLabel: "Resend") {
                print("Otp \(otp)")
                timeLeft = 60
                confirmActivationCodeRequest(phoneNumber)
            }
            .disabled(timeLeft > 0)
            .opacity(timeAdvice.isEmpty  ? 1 : 0.5)
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
        .onReceive(timer) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
                timeAdvice = "Resend code in 0:\(timeLeft)"
            } else {
                timeAdvice = ""
            }
        }
    }
    fileprivate func confirmActivationCodeRequest(_ fullPhoneNumber: String) {
        var request = TinggRequest()
        print("Phone number \(fullPhoneNumber)")
        request.confirmActivationCode(service: "VAK",
                                      msisdn: fullPhoneNumber,
                                      clientId: self.activeCountry.mulaClientID!, code: otp)
        Task {
            confirmActivationCode.confirmCode(activationCodeRequest: request) { result in
                print("Confirmation result \(result)")
            }
        }
    }
}

struct OtpConfirmationView_Previews: PreviewProvider {
    struct  OtpConfirmationViewHolder: View {
        @State var country: Country = .init()
        @State var phoneNumber: String = ""
        var body: some View {
            OtpConfirmationView(activeCountry: $country, phoneNumber: $phoneNumber)
        }
    }
    static var previews: some View {
        OtpConfirmationViewHolder()
    }
}
