//
//  OtpConfirmationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 08/07/2022.
//
import Combine
import Common
import Core
import SwiftUI
import Theme

public struct OtpConfirmationView: View {
    @State var otpSize = 4
    @State var otp = ""
    @State var timeLeft = 60
    @State var timeAdvice = ""
    @State private var subscriptions = Set<AnyCancellable>()
    @Binding var activeCountry: Country
    @Binding var phoneNumber: String
    @Binding var otpConfirmed: Bool
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        VStack(alignment: .center) {
            Text("Confirm OTP")
                .fontWeight(.bold)
            Divider()
            Text("Enter the code received via SMS\nto confirm request")
                .smallTextViewStyle(SmallTextStyle())
            OtpFieldView(fieldSize: $otpSize, otpValue: $otp, focusColor: PrimaryTheme.getColor(.primaryColor))
                .padding(.vertical, 20)
            Text(timeAdvice)
                .smallTextViewStyle(SmallTextStyle())
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Confirm"
            ) {
                onboardingViewModel.confirmActivationCodeRequest(code: otp)
            }
        }
        .handleViewState(uiModel: $onboardingViewModel.uiModel)
        .padding(20)
        .onReceive(timer) { _ in
            handleCountDown()
        }
        .onAppear {
            observingUIModel()
        }
    }
    fileprivate func resetTimer() {
        timeLeft = 60
    }
    fileprivate func handleCountDown() {
        if timeLeft > 0 {
            timeLeft -= 1
            if timeLeft < 10 {
                timeAdvice = "Resend code in 00:0\(timeLeft)"
            } else {
                timeAdvice = "Resend code in 00:\(timeLeft)"
            }
        } else {
            onboardingViewModel.makeActivationCodeRequest()
            timeAdvice = "Code resent"
            resetTimer()
        }
    }
    fileprivate func observingUIModel() {
        onboardingViewModel.observeUIModel { data in
            print("OTP \(data)")
            if data is BaseDTO, data.statusMessage.lowercased().contains("confirm") {
                print("OTPInside \(data)")
                otpConfirmed.toggle()
                $onboardingViewModel.showOTPView.wrappedValue = false
            }
            print("OTPAfter \(data)")
        }
    }
}

struct OtpConfirmationView_Previews: PreviewProvider {
    struct  OtpConfirmationViewHolder: View {
        @State var country: Country = .init()
        @State var phoneNumber: String = ""
        @State var confirmedOTP: Bool = false
        var body: some View {
            OtpConfirmationView(activeCountry: $country, phoneNumber: $phoneNumber, otpConfirmed: $confirmedOTP)
        }
    }
    static var previews: some View {
        OtpConfirmationViewHolder()
            .environmentObject(OnboardingDI.createOnboardingViewModel())
    }
}
