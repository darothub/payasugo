//
//  PhoneNumberValidationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//  swiftlint:disable all

import Combine
import CoreNavigation
import CoreUI
import Core
import SwiftUI
import Theme
/// The view for phone number input and validation
/// User can also have access to support features
/// Upon successful input validation user is taken to ``OtpConfirmationView``
/// User is directed to the Home view after OTP confirmation 
public struct PhoneNumberValidationView: View {
    @AppStorage(Utils.defaultNetworkServiceId) var defaultNetworkServiceId: String = ""
    @StateObject var vm = OnboardingDI.createOnboardingViewModel()
    @Environment(\.openURL) var openURL
    @EnvironmentObject var navigation: NavigationUtils
    @Environment(\.realmManager) var realmManager
    @State private var showOTPView = false
    @State private var isOTPConfirmed = false
    @State private var phoneNumber = ""
    @State private var countryCode = ""
    @State private var countryFlag = ""
    @State private var isValidPhoneNumber = false
    @State private var isNotValidPhoneNumber = false
    @State private var warning = ""
    @State private var hasCheckedTermsAndPolicy = false
    @State private var showSupportTeamContact = false
    @State private var showMAKAlert = false
    @State private var showPARAlert = false
    public static var policyWarning = "Kindly accept terms and policy"
    public static var phoneNumberEmptyWarning = "Phone number must not be empty"
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                topView(geo: geometry)
                MobileNumberView()
                CountryPickerView(phoneNumber: $phoneNumber, countryCode: $countryCode, countryFlag: $countryFlag, countries: vm.countryDictionary)
                    .textFiedStyle(
                        TextFiedValidationStyle(
                            isValid: $isValidPhoneNumber, notValid: $isNotValidPhoneNumber
                        )
                    )
                    .onChange(
                        of: phoneNumber,
                        perform: onPhoneNumberInput(number:)
                    )
                VerificationCodeAdviceTextView()
                PolicySectionView(hasCheckedTermsAndPolicy: $hasCheckedTermsAndPolicy)
                Spacer()
                TinggSupportSectionView(geometry: geometry, showSupportTeamContact: $showSupportTeamContact)
                TinggButton(
                    backgroundColor: PrimaryTheme.getColor(.primaryColor),
                    buttonLabel: "Continue"
                ) {
                    prepareActivationRequest()
                }
                .accessibility(identifier: "continuebtn")
                .padding()
                .keyboardShortcut(.return)
                
                  .handleViewStates(uiModel: $vm.onActivationRequestUIModel, showAlert: $showMAKAlert, showSuccessAlert: $showMAKAlert)

            }
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Contact", isPresented: $showSupportTeamContact) {
               callSupportActions()
            } message: {
                Text("Support")
            }
            .sheet(isPresented: $showOTPView, onDismiss: {
                if isOTPConfirmed {
                    vm.makePARRequest()
                }
            }, content: {
                OtpConfirmationView(
                    otpConfirmed: $isOTPConfirmed
                )
            })
            .background(PrimaryTheme.getColor(.tinggwhite))
            .onAppear {
                observeUIModel()
            }
            .handleViewStates(uiModel: $vm.phoneNumberFieldUIModel, showAlert: $showMAKAlert, showSuccessAlert: $showMAKAlert)
            .handleViewStates(uiModel: $vm.onParRequestUIModel, showAlert: $showPARAlert)
        }
    }
    @ViewBuilder
    fileprivate func topRectangleBackground(geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(PrimaryTheme.getColor(.cellulantLightGray))
            .frame(width: geometry.size.width, height: abs(geometry.size.height * 1.4 * 0.25))
            .edgesIgnoringSafeArea(.all)
    }
    @ViewBuilder
    fileprivate func topCameraImage(geometry: GeometryProxy) -> some View {
        Image(systemName: "camera.fill")
            .frame(width: geometry.size.width * 0.21,
                   height: geometry.size.height * 0.1,
                   alignment: .center)
            .scaleEffect(1.5)
            .foregroundColor(PrimaryTheme.getColor(.cellulantRed))
            .background(.white)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .shadow(radius: 3)
            .padding(.bottom, 10)
            .alignmentGuide(VerticalAlignment.top) { align in
                -align[VerticalAlignment.center] * 0.5
            }
    }
    @ViewBuilder
    fileprivate func topView(geo: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            topRectangleBackground(geometry: geo)
        }
        .frame(width: geo.size.width, height: abs(geo.size.height * 0.25))
    }
    @ViewBuilder
    fileprivate func callSupportActions() -> some View {
        Button("Call Ting Support") {
            callSupport()
        }
        Button("Chat Ting Support") {
            print("Chat")
        }
        Button("Cancel", role: .cancel) {
            // Intentionally unimplemented...no cancel action
        }
    }
}

struct PhoneNumberValidationView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberValidationView()
    }
}

extension PhoneNumberValidationView {
    fileprivate func callSupport() {
        let tel = "tel://"
        let supportNumber = "+254708802299"
        let formattedPhoneNumber = tel+supportNumber
        guard let url = URL(string: formattedPhoneNumber) else {return}
        openURL(url)
    }
    fileprivate func gotoHomeView() {
        navigation.navigationStack.append(Screens.home)
    }
    
    fileprivate func observeUIModel() {
        vm.observeUIModel(model: vm.$onActivationRequestUIModel, subscriptions: &vm.subscriptions) { content in
            showOTPView = true
        } onError: { err in
            showMAKAlert = true
            log(message: err)
        }
        vm.observeUIModel(model: vm.$phoneNumberFieldUIModel, subscriptions: &vm.subscriptions) { content in
            log(message: content.statusMessage)
        } onError: { err in
            showMAKAlert = true
            log(message: err)
        }
        vm.observeUIModel(model: vm.$onParRequestUIModel, subscriptions: &vm.subscriptions) { content in
            gotoHomeView()
        } onError: { err in
            showPARAlert = true
            log(message: err)
        }
    }
    fileprivate func onPhoneNumberInput(number: String) -> Void {
        isValidPhoneNumber = validatePhoneNumberInput(number: "\(countryCode)\(phoneNumber)")
        isNotValidPhoneNumber = !isValidPhoneNumber
    }
    fileprivate func prepareActivationRequest() {
        let isPhoneNumberNotEmpty = validatePhoneNumberIsNotEmpty(number: phoneNumber)
        
        if !isPhoneNumberNotEmpty {
            showMAKAlert = true
            vm.phoneNumberFieldUIModel = UIModel.error(PhoneNumberValidationView.phoneNumberEmptyWarning)
            return
        }
        if !isValidPhoneNumber {
            showMAKAlert = true
            vm.phoneNumberFieldUIModel = UIModel.error("Invalid phone number")
            return
        }
        if !hasCheckedTermsAndPolicy {
            showMAKAlert = true
            vm.phoneNumberFieldUIModel = UIModel.error(PhoneNumberValidationView.policyWarning)
            return
        }
        let number = "\(countryCode)\(phoneNumber)"
        AppStorageManager.retainPhoneNumber(number: number)
        if let country = getCountryByDialCode(dialCode: countryCode) {
            AppStorageManager.retainActiveCountry(country: country)
        }
        vm.makeActivationCodeRequest()
    }
    func validatePhoneNumberInput(number: String) -> Bool {
        var result = false
        if let regex = getSelectedCountryRegexByDialcode(dialCode: countryCode) {
            result = validatePhoneNumber(with: regex, phoneNumber: number)
        }
        if  number.count < 8 {
            result = false
        }
        return result
    }
    
    func getSelectedCountryRegexByDialcode(dialCode: String) -> String? {
        if let country = getCountryByDialCode(dialCode: dialCode)  {
            return country.countryMobileRegex
        }
        return nil
    }
    
    func getCountryByDialCode(dialCode: String) -> Country? {
        if let country = vm.getCountryByDialCode(dialCode: dialCode)  {
            return country
        }
        return nil
    }
}

