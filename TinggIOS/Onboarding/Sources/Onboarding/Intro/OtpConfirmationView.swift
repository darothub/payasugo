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

///  Displays OTP text field for confirmation.
///  Upon successful OTP confirmation user returns to Phone number verification view.
public struct OtpConfirmationView: View {
    
    
    @State private var otpSize = 4
    @State private var otp = ""
    @State private var timeLeft = 60
    @State private var timeAdvice = ""
    @Binding var otpConfirmed: Bool
    @StateObject private var otpViewOVM = OnboardingDI.createOnboardingViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var onSubmit = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        VStack(alignment: .center) {
            Text("Confirm OTP")
                .fontWeight(.bold)
            Divider()
            Text("Enter the code received via SMS\nto confirm request")
                .smallTextViewStyle(SmallTextStyle())
                .foregroundColor(PrimaryTheme.getColor(.tinggblack))
            OtpFieldView(fieldSize: otpSize, otpValue: $otp, focusColor: PrimaryTheme.getColor(.primaryColor))
                .padding(.vertical, 20)
            Text(timeAdvice)
                .smallTextViewStyle(SmallTextStyle())
                .foregroundColor(PrimaryTheme.getColor(.tinggblack))
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Confirm"
            ) {
                otpViewOVM.confirmActivationCodeRequest(code: otp)
               
            }.handleViewStates(uiModel: $otpViewOVM.onConfirmActivationUIModel, showAlert: $showErrorAlert, showSuccessAlert: $showSuccessAlert)
            
        }
        .padding(20)
        .onReceive(timer) { _ in
            handleCountDown()
        }
        .onAppear {
            observingUIModel()
        }
        
    }
    /// Reset the count down timer for OTP receipt
    fileprivate func resetTimer() {
        timeLeft = 60
    }
    /// Handles countdown timer
    /// A new otp request is made when the countdown times out
    fileprivate func handleCountDown() {
        if timeLeft > 0 {
            timeLeft -= 1
            if timeLeft < 10 {
                timeAdvice = "Resend code in 00:0\(timeLeft)"
            } else {
                timeAdvice = "Resend code in 00:\(timeLeft)"
            }
        } else {
            otpViewOVM.makeActivationCodeRequest()
            timeAdvice = "Code resent"
            resetTimer()
        }
    }
    /// Observes the UI state
    fileprivate func observingUIModel() {
        otpViewOVM.observeUIModel(model: otpViewOVM.$onConfirmActivationUIModel, subscriptions: &otpViewOVM.subscriptions) { content in
            dismiss()
            otpConfirmed = true
        } onError: { err in
            showErrorAlert = true
            print("OTPView \(err)")
        }
    }
}

struct OtpConfirmationView_Previews: PreviewProvider {
    struct  OtpConfirmationViewHolder: View {
        @State var country: Country = .init()
        @State var phoneNumber: String = ""
        @State var confirmedOTP: Bool = false
        var body: some View {
            OtpConfirmationView(otpConfirmed: $confirmedOTP)
        }
    }
    static var previews: some View {
        OtpConfirmationViewHolder()
    }
}
