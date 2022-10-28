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
    let key = KeyEquivalent("p")
    @Environment(\.openURL) var openURL
    @EnvironmentObject var navigation: NavigationUtils
    @State private var subscriptions = Set<AnyCancellable>()
    @Environment(\.realmManager) var realmManager
    var categoriesDbObserver = Observer<Categorys>()
    var merchantServicesDbObserver = Observer<MerchantService>()
    var enrollmentDbObserver = Observer<Enrollment>()
    var transactionHistoryDbObserver = Observer<TransactionHistory>()
    var profileDbObserver = Observer<Profile>()
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                topView(geo: geometry)
                MobileNumberView()
                CountryPickerView(phoneNumber: $vm.phoneNumber, countryCode: $vm.countryCode, countryFlag: $vm.countryFlag, countries: vm.countryDictionary)
                    .countryFieldViewStyle(
                        CountryViewDropDownStyle(
                            isValidPhoneNumber: $vm.isValidPhoneNumber
                        )
                    )
                    .onChange(
                        of: vm.phoneNumber,
                        perform: onPhoneNumberInput(number:)
                    )
                    .handleViewStates(uiModel: $vm.phoneNumberFieldUIModel, showAlert: $vm.showAlert)
                VerificationCodeAdviceTextView()
                PolicySectionView()
                    .environmentObject(vm)
                Spacer()
                TinggSupportSectionView(geometry: geometry)
                    .environmentObject(vm)
                SubmitButtonView()
                    .environmentObject(vm)
            }
            .alert(vm.warning, isPresented: $vm.showAlert) {
                warningButtonAction()
            }
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Contact", isPresented: $vm.showSupportTeamContact) {
               callSupportActions()
            } message: {
                Text("Support")
            }
            .sheet(isPresented: $vm.showOTPView, onDismiss: {
                if vm.confirmedOTP {
                    vm.makePARRequest()
                }
            }, content: {
                OtpConfirmationView(
                    activeCountry: $vm.currentCountry,
                    phoneNumber: $vm.phoneNumber,
                    otpConfirmed: $vm.confirmedOTP
                ).environmentObject(vm)
            })
            .background(PrimaryTheme.getColor(.tinggwhite))
            .handleViewStates(uiModel: $vm.uiModel, showAlert: $vm.showAlert)
            .onAppear {
                observeUIModel()
            }
        }
    }
    fileprivate func observeUIModel() {
        vm.observeUIModel(model: vm.$uiModel) { dto in
            confirmRegistration(data: dto)
        }
    }
    fileprivate func onPhoneNumberInput(number: String) -> Void {
        vm.verifyPhoneNumber(number: number)
    }
    @ViewBuilder
    fileprivate func topView(geo: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            topRectangleBackground(geometry: geo)
        }
        .frame(width: geo.size.width, height: abs(geo.size.height * 0.25))
    }
    fileprivate func callSupport() {
        let tel = "tel://"
        let supportNumber = "+254708802299"
        let formattedPhoneNumber = tel+supportNumber
        guard let url = URL(string: formattedPhoneNumber) else {return}
        openURL(url)
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
    fileprivate func topRectangleBackground(geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(PrimaryTheme.getColor(.cellulantLightGray))
            .frame(width: geometry.size.width, height: abs(geometry.size.height * 1.4 * 0.25))
            .edgesIgnoringSafeArea(.all)
    }
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
    func confirmRegistration(data: BaseDTOprotocol) {
        if let parResponse = data as? PARAndFSUDTO, !vm.showOTPView && vm.confirmedOTP  {
            Task {
                let sortedCategories = parResponse.categories.sorted { category1, category2 in
                    Int(category1.categoryOrderID!)! < Int(category2.categoryOrderID!)!
                }.filter { category in
                    category.activeStatus == "1"
                }
                realmManager.save(data: sortedCategories)
                let services = parResponse.services.filter { service in
                    service.activeStatus != "0"
                }
                realmManager.save(data: services)
                realmManager.save(data: parResponse.transactionSummaryInfo)
                let nominationInfo = parResponse.nominationInfo.filter { enrolment in
                    enrolment.isReminder == "0" && enrolment.accountStatus == 1
                }
                realmManager.save(data: nominationInfo)
                let profile = parResponse.mulaProfileInfo.mulaProfile[0]
                realmManager.save(data: profile)
                defaultNetworkServiceId = parResponse.defaultNetworkServiceID ?? ""
//                navigation.screen = .home
                navigation.navigationStack = [.home]
            }
        }
    }
}

extension OnboardingViewModel {
    func verifyPhoneNumber(number: String) {
        let phoneNumber = "+\(countryCode)\(number)"
        do {
            let regex = try getSelectedCountryRegex()
            isValidPhoneNumber = validatePhoneNumber(with: regex, phoneNumber: phoneNumber)
            if  number.count < 8 {
                isValidPhoneNumber = false
                return
            }
            isValidPhoneNumber = true
        } catch {
            phoneNumberFieldUIModel = UIModel.error(error.localizedDescription)
        }
    }
    func getSelectedCountryRegex() throws -> String {
        guard getCountryByDialCode(dialCode: countryCode) != nil else {
            throw "Country witn \(countryCode) not found"
        }
        guard let regex = currentCountry.countryMobileRegex else { return ""}
        return regex
    }

}
