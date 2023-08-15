//
//  OtpConfirmationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 08/07/2022.
//
import Combine
import Core
import CoreNavigation
import CoreUI
import SwiftUI
import Theme

///  Displays OTP text field for confirmation.
///  Upon successful OTP confirmation user returns to Phone number verification view.
public struct OtpConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigation: NavigationManager
    @StateObject private var otpVM = OnboardingDI.createOnboardingVM()
    @State private var otpSize = 4
    @State private var otp = ""
    @State private var timeAdvice = "Resend code in "
    @State private var activateButton = false
    @State private var timer: Timer?
    @State private var remainingTime = 60

    public var body: some View {
        VStack(alignment: .center) {
            Text("Confirm OTP")
                .fontWeight(.bold)
                .foregroundColor(.black)
            Divider()
            Text("Enter the code received via SMS\nto confirm request")
                .smallTextViewStyle(SmallTextStyle())
                .foregroundColor(PrimaryTheme.getColor(.tinggblack))
            PINTextFieldView(fieldSize: otpSize, otpValue: $otp, focusColor: PrimaryTheme.getColor(.primaryColor))

            Text("Resend code in \(timeAdvice)")
                .smallTextViewStyle(SmallTextStyle())
                .foregroundColor(PrimaryTheme.getColor(.tinggblack))

            TinggButton(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Confirm",
                isActive: $activateButton

            ) {
                otpVM.confirmActivationCode(otp: otp)
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .onAppear {
            startCountdown()
        }
        .onChange(of: otp) { _ in
            activateButton = otp.count == otpSize
        }
        .onChange(of: remainingTime, perform: { newValue in
            if newValue < 10 {
                timeAdvice = "00:0\(newValue)"
            } else {
                timeAdvice = "00:\(newValue)"
            }
        })

        .handleViewStatesMods(uiState: otpVM.$onConfirmActivationUIModel) { _ in
            stopCountdown()
            otpVM.fetchSystemUpdate()
        }
        .handleViewStatesMods(uiState: otpVM.$uiModel) { content in
            let data = content.data as! SystemUpdateDTO
            log(message: data)
            dismiss()
            gotoHomeView()
        }
        .onDisappear {
            stopCountdown()
        }
    }

    func startCountdown() {
        guard timer == nil else {
            return // Timer is already running
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                otpVM.otpRequest()
                timeAdvice = "Code resent"
                remainingTime = 60
            }
        }
    }

    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }

    fileprivate func gotoHomeView() {
        do {
            guard let data = try TinggSecurity.simpleEncryption(true) else {
                return
            }
            AppStorageManager.setIsLogin(value: data)
        } catch {
            otpVM.uiModel = UIModel.error("Error writing user session")
        }
        withAnimation {
            navigation.goHome()
        }
    }
}

struct OtpConfirmationView_Previews: PreviewProvider {
    struct OtpConfirmationViewHolder: View {
        @State var country: CountriesInfoDTO = .init()
        @State var phoneNumber: String = ""
        @State var confirmedOTP: Bool = false
        var body: some View {
            OtpConfirmationView()
        }
    }

    static var previews: some View {
        OtpConfirmationViewHolder()
    }
}
