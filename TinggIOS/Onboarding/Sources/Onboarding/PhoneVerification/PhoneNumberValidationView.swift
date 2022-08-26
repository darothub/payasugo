//
//  PhoneNumberValidationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//

import Combine
import Common
import Core
import SwiftUI
import Theme
public struct PhoneNumberValidationView: View {

    // swiftlint:disable all
    @StateObject var vm = OnboardingDI.createOnboardingViewModel()
    var dbTransactionController: DBTransactions = .init()
    let key = KeyEquivalent("p")
    @Environment(\.openURL) var openURL
    @EnvironmentObject var navigation: NavigationUtils
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                topView(geo: geometry)
                MobileNumberView()
                countryCodeViewActions()
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
            .handleViewState(uiModel: $vm.uiModel)
            .onAppear {
                observingUIModel()
            }
        }
    }
    
    fileprivate func observingUIModel() {
        vm.observeUIModel { data in
            confirmRegistration(data: data)
        }
    }
    @ViewBuilder
    fileprivate func countryCodeViewActions() -> some View {
        CountryCodesView(phoneNumber: $vm.phoneNumber, countryCode: $vm.countryCode, countries: $vm.countryDictionary)
            .countryFieldViewStyle(
                CountryViewDropDownStyle(
                    isValidPhoneNumber: $vm.isValidPhoneNumber
                )
            )
            .onChange(of: vm.phoneNumber) { number in
                vm.verifyPhoneNumber(number: number)
            }
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
        if data is BaseDTO {
            $vm.showOTPView.wrappedValue = true
        } else {
            $vm.showOTPView.wrappedValue = false
        }
        if let parResponse = data as? PARAndFSUDTO, !vm.showOTPView && vm.confirmedOTP  {
            Task {
                let sortedCategories = parResponse.categories.sorted { category1, category2 in
                    Int(category1.categoryOrderID!)! < Int(category2.categoryOrderID!)!
                }.filter { category in
                    category.activeStatus == "1"
                }
                vm.saveObjects(data: sortedCategories)
                vm.saveObjects(data: parResponse.services)
                vm.saveObjects(data: parResponse.transactionSummaryInfo)
                let nominationInfo = parResponse.nominationInfo.filter { enrolment in
                    enrolment.isReminder == "0" && enrolment.accountStatus == 1
                }
                vm.saveObjects(data: nominationInfo)
                let profile = parResponse.mulaProfileInfo.mulaProfile[0]
                vm.save(data: profile)
                navigation.screen = .home
            }
        }
    }
}

extension OnboardingViewModel {
    func verifyPhoneNumber(number: String) {
        let phoneNumber = "+\(countryCode)\(number)"
        let regex = getSelectedCountryRegex()
        guard validatePhoneNumberWith(regex: regex, phoneNumber: phoneNumber) != nil
        else {
            isValidPhoneNumber = false
            return
        }
        if  number.count < 8 {
            isValidPhoneNumber = false
            return
        }
        isValidPhoneNumber = true
    }
    func getSelectedCountryRegex() -> String {
        guard let country = getCountryByDialCode(dialCode: countryCode) else {
            printLn(methodName: "getSelectedCountryRegex", message: "country is nil")
            return ""
        }
        self.currentCountry = country
        guard let regex = currentCountry.countryMobileRegex else { return ""}
        return regex
    }
    func validatePhoneNumberWith(regex: String, phoneNumber: String) -> [NSTextCheckingResult]? {
        let phoneRegex = try? NSRegularExpression(
            pattern: regex,
            options: []
        )
        let sourceRange = NSRange(
            phoneNumber.startIndex..<phoneNumber.endIndex,
            in: phoneNumber
        )
        let result = phoneRegex?.matches(
            in: phoneNumber,
            options: [],
            range: sourceRange
        )
        return result
    }

}
