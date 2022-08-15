//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//
import Common
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
              let isValidated = onboardingViewModel.validatePhoneNumberIsNotEmpty()
              if isValidated {
                  let number = "+\($onboardingViewModel.countryCode)\($onboardingViewModel.phoneNumber)"
                  onboardingViewModel.makeActivationCodeRequest(
                    msisdn: number,
                    clientId: $onboardingViewModel.currentCountry.wrappedValue.mulaClientID!
                  )
              }
          }.keyboardShortcut(.return)
            .accessibility(identifier: "continuebtn")
        }
    }
}

struct SubmitButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButtonView()
            .environmentObject(OnboardingViewModel(
                countryRepository: CountryRepositoryImpl(
                    apiService: BaseRepository(),
                    realmManager: RealmManager()
                ),
                baseRequest: BaseRequest(apiServices: BaseRepository())
            )
        )
    }
}

extension OnboardingViewModel {
    func validatePhoneNumberIsNotEmpty() -> Bool {
        if phoneNumber.isEmpty {
            warning = "Phone number can not be empty"
            showAlert.toggle()
            return false
        }
        if !isCheckedTermsAndPolicy {
            warning = "You must accept terms of use and privacy policy to proceed!"
            showAlert.toggle()
            return false
        }
        return true
    }
}
