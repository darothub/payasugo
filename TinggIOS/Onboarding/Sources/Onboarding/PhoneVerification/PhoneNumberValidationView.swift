//
//  PhoneNumberValidationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//  swiftlint:disable all

import Combine
import Common
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
    @State private var warning = ""
    @State private var hasCheckedTermsAndPolicy = false
    @State private var showSupportTeamContact = false
    @State private var showAlert = false
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                topView(geo: geometry)
                MobileNumberView()
                CountryPickerView(phoneNumber: $phoneNumber, countryCode: $countryCode, countryFlag: $countryFlag, countries: vm.countryDictionary)
                    .countryFieldViewStyle(
                        CountryViewDropDownStyle(
                            isValidPhoneNumber: $isValidPhoneNumber
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
                button(
                    backgroundColor: PrimaryTheme.getColor(.primaryColor),
                    buttonLabel: "Continue"
                ) {
                    prepareActivationRequest()
                }.keyboardShortcut(.return)
                  .accessibility(identifier: "continuebtn")
                  .handleViewStates(uiModel: $vm.onActivationRequestUIModel, showAlert: $showAlert, showSuccessAlert: $showAlert)

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
            .handleViewStates(uiModel: $vm.onParRequestUIModel, showAlert: $showAlert)
            .handleViewStates(uiModel: $vm.phoneNumberFieldUIModel, showAlert: $showAlert, showSuccessAlert: $showAlert)
            .background(PrimaryTheme.getColor(.tinggwhite))
            .onAppear {
                observeUIModel()
            }
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
    fileprivate func warningButtonAction() -> some View {
        Button("OK", role: .cancel) {
            //todo action
        }.accessibility(identifier: "warningbutton")
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
    fileprivate func observeUIModel() {
        vm.observeUIModel(model: vm.$onActivationRequestUIModel, subscriptions: &vm.subscriptions) { content in
            showOTPView = true
        } onError: { err in
            showAlert = true
            log(message: err)
        }
        vm.observeUIModel(model: vm.$onParRequestUIModel, subscriptions: &vm.subscriptions) { content in
            let dto = content.data as! PARAndFSUDTO
            saveDataIntoDBAndNavigateToHome(data: dto)
        } onError: { err in
            showAlert = true
            log(message: err)
        }
        vm.observeUIModel(model: vm.$phoneNumberFieldUIModel, subscriptions: &vm.subscriptions) { content in
            log(message: content.statusMessage)
        } onError: { err in
            showAlert = true
            log(message: err)
        }
    }
    fileprivate func onPhoneNumberInput(number: String) -> Void {
        isValidPhoneNumber = validatePhoneNumberInput(number: "\(countryCode)\(phoneNumber)")
    }
    fileprivate func prepareActivationRequest() {
        let isPhoneNumberNotEmpty = validatePhoneNumberIsNotEmpty(number: phoneNumber)
        
        if !isPhoneNumberNotEmpty {
            showAlert = true
            vm.phoneNumberFieldUIModel = UIModel.error("Phone number must not be empty")
            return
        }
        if !isValidPhoneNumber {
            showAlert = true
            vm.phoneNumberFieldUIModel = UIModel.error("Invalid phone number")
            return
        }
        if !hasCheckedTermsAndPolicy {
            showAlert = true
            vm.phoneNumberFieldUIModel = UIModel.error("Kindly accept terms and policy")
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
    func saveDataIntoDBAndNavigateToHome(data: PARAndFSUDTO) {
        Task {
            let sortedCategories = data.categories.sorted { category1, category2 in
                Int(category1.categoryOrderID!)! < Int(category2.categoryOrderID!)!
            }.filter { category in
                category.activeStatus == "1"
            }
            realmManager.save(data: sortedCategories)
            let services = data.services.filter { service in
                service.activeStatus != "0"
            }
            realmManager.save(data: services)
            realmManager.save(data: data.transactionSummaryInfo)
            let nominationInfo = data.nominationInfo.filter { enrolment in
                enrolment.isReminder == "0" && enrolment.accountStatus == 1
            }
            realmManager.save(data: nominationInfo)
            let profile = data.mulaProfileInfo.mulaProfile[0]
            realmManager.save(data: profile)
            Observer<BundleData>().getEntities().forEach { data in
                realmManager.delete(data: data)
            }
            Observer<BundleObject>().getEntities().forEach { data in
                realmManager.delete(data: data)
            }
            realmManager.save(data: data.cardDetails)
            let payers: [MerchantPayer] = data.merchantPayers.map {$0.convertToPayer()}
            realmManager.save(data: data.securityQuestions)
            realmManager.save(data: payers)
            realmManager.save(data: data.bundleData.map {$0.convert()})
            
            if let defaultNetworkId = data.defaultNetworkServiceID {
                log(message: "\(defaultNetworkId)")
                AppStorageManager.setDefaultNetworkId(id: String(defaultNetworkId))
            }
          
            navigation.navigationStack = [.home]
        }
    }
}

