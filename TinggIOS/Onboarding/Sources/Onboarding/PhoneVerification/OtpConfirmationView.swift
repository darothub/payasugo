//
//  OtpConfirmationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 08/07/2022.
//
import Combine
import CoreUI
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
//    @StateObject private var otpViewOVM = OnboardingDI.createOnboardingViewModel()
    @StateObject private var otpVM = OnboardingDI.createOnboardingVM()
    @State var disableButton = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var onSubmit = false
    @State private var activateButton = false
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
            TinggButton(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Confirm",
                isActive: $activateButton
                
            ) {
                let confirmOTPRequest: RequestMap =  RequestMap.Builder()
                    .add(value: "VAK", for: .SERVICE)
                    .add(value: otp, for: .ACTIVATION_CODE)
                    .build()
                otpVM.confirmActivationCode(request: confirmOTPRequest)
               
            }
            .padding(20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .onReceive(timer) { _ in
            handleCountDown()
        }
        .onChange(of: otp) { newValue in
            activateButton = otp.count == otpSize
        }
        .handleUIState(uiState: $otpVM.onConfirmActivationUIModel) { content in
            dismiss()
            otpConfirmed = true
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
            let activationCodeRequest: RequestMap = RequestMap.Builder()
                .add(value: "MAK", for: .SERVICE)
                .build()
            otpVM.getActivationCode(request: activationCodeRequest)
            timeAdvice = "Code resent"
            resetTimer()
        }
    }

}

struct OtpConfirmationView_Previews: PreviewProvider {
    struct  OtpConfirmationViewHolder: View {
        @State var country: CountriesInfoDTO = .init()
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



