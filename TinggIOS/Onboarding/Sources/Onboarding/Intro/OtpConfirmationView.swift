//
//  OtpConfirmationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 08/07/2022.
//
import Common
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
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
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
                onboardingViewModel.confirmActivationCodeRequest(
                    msisdn: phoneNumber, clientId: activeCountry.mulaClientID!, code: otp
                )
            }.onReceive(onboardingViewModel.$results) { result in
                switch result {
                case .success(let data):
                    onboardingViewModel.retainActiveCountry(country: self.activeCountry.country!)
                    onboardingViewModel.makePARRequest(
                        msisdn: phoneNumber, clientId: activeCountry.mulaClientID!
                    )
                    onboardingViewModel.resetMessage()
                    dismiss()
                case .failure(let err):
                    print("Error \(err.localizedDescription)")
                    return
                }
//                if !message.contains("Success") {
//                    return
//                }
                print("Activo \(self.activeCountry)")
                
            }
        }
        .handleViewState(isLoading: $onboardingViewModel.showLoader, message: $onboardingViewModel.message)
        .padding(20)
        .onReceive(timer) { _ in
            handleCountDown()
        }.onAppear {
            onboardingViewModel.results = Result.failure(.networkError)
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
            onboardingViewModel.makeActivationCodeRequest(
                msisdn: phoneNumber, clientId: activeCountry.mulaClientID!
            )
            timeAdvice = "Code resent"
            resetTimer()
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
            .environmentObject(OnboardingViewModel(tinggApiServices: BaseRepository()))
    }
}
