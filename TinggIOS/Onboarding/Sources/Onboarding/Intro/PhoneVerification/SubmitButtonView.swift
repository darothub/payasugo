//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//
import Core
import SwiftUI
import Theme
struct SubmitButtonView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    var body: some View {
        NavigationLink(
            destination: IntroView(),
            isActive: $onboardingViewModel.navigate) {
          button(
              backgroundColor: PrimaryTheme.getColor(.primaryColor),
              buttonLabel: "Continue"
          ) {
              onboardingViewModel.validatePhoneNumberIsNotEmpty()
              let number = "+\($onboardingViewModel.countryCode)\($onboardingViewModel.phoneNumber)"
              onboardingViewModel.makeActivationCodeRequest(
                msisdn: number,
                clientId: $onboardingViewModel.currentCountry.wrappedValue.mulaClientID!
              )
          }.keyboardShortcut(.return)
        }
    }
}

struct SubmitButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButtonView()
            .environmentObject(OnboardingViewModel(tinggApiServices: BaseRepository()))
    }
}


extension OnboardingViewModel {
    func validatePhoneNumberIsNotEmpty() {
        if phoneNumber.isEmpty {
            warning = "Phone number can not be empty"
            showAlert.toggle()
            return
        }
        if !isCheckedTermsAndPolicy {
            warning = "You must accept terms of use and privacy policy to proceed!"
            showAlert.toggle()
            return
        }
    }
}
