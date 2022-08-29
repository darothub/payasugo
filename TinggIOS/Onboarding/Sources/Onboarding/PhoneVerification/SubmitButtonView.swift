//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//
import Combine
import Common
import Core
import SwiftUI
import Theme
struct SubmitButtonView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State private var subscriptions = Set<AnyCancellable>()
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
                  onboardingViewModel.retainPhoneNumber()
                  onboardingViewModel.saveActiveCountry(countryName: onboardingViewModel.currentCountry.name!)
                  onboardingViewModel.saveClientId(clientId: onboardingViewModel.currentCountry.mulaClientID!)
                  onboardingViewModel.makeActivationCodeRequest()
                  observeUIModel()
              }
          }.keyboardShortcut(.return)
            .accessibility(identifier: "continuebtn")
        }
        .handleViewState(uiModel: $onboardingViewModel.onSubmitUIModel)
    }
    
    func observeUIModel() {
        onboardingViewModel.observeUIModel(model: onboardingViewModel.$onSubmitUIModel) { dto in
            print("submit \(dto)")
            onboardingViewModel.showOTPView = true

        }
    }
}

struct SubmitButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButtonView()
            .environmentObject(OnboardingDI.createOnboardingViewModel())

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
    func retainPhoneNumber() {
        print("ActiveNumber \(countryCode)\(phoneNumber)")
        AppStorageManager.retainPhoneNumber(number: countryCode+phoneNumber)
    }
    func saveActiveCountry(countryName: String) {
        AppStorageManager.retainActiveCountry(country: countryName)
    }
    func saveClientId(clientId: String) {
        AppStorageManager.retainClientId(id: clientId)
    }
}
