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
    @State var showLoader = false
    @Binding var activeCountry: Country
    @Binding var phoneNumber: String
    @StateObject var confirmActivationCode: ConfirmActivationCode = .init()
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var theme: PrimaryTheme = .init()
    var body: some View {
        VStack(alignment: .center) {
            Text("Confirm OTP")
                .fontWeight(.bold)
            Divider()
            Text("Enter the code received via SMS\nto confirm request")
                .smallTextViewStyle(SmallTextStyle(theme: theme))
            OtpFieldView(fieldSize: $otpSize, otpValue: $otp)
                .padding(.vertical, 20)
            Text(timeAdvice)
                .smallTextViewStyle(SmallTextStyle(theme: theme))
            UtilViews.button(backgroundColor: theme.primaryColor, buttonLabel: "Resend") {
                print("Otp \(otp)")
                timeLeft = 60
            }
            .disabled(timeLeft > 0)
            .opacity(timeAdvice.isEmpty  ? 1 : 0.5)
            UtilViews.button(backgroundColor: theme.primaryColor, buttonLabel: "Confirm") {
                showLoader.toggle()
                onboardingViewModel.confirmActivationCodeRequest(
                    msisdn: phoneNumber, clientId: activeCountry.mulaClientID!, code: otp
                )
            }
        }
        .handleViewState(isLoading: $onboardingViewModel.showLoader, message: $onboardingViewModel.message)
        .padding(20)
        .onReceive(timer) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
                timeAdvice = "Resend code in 0:\(timeLeft)"
            } else {
                timeAdvice = ""
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
            .environmentObject(OnboardingViewModel())
    }
}