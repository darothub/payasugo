//
//  PhoneNumberValidationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//

import Combine
import Core
import SwiftUI
import Theme
public struct PhoneNumberValidationView: View {
    @StateObject var onboardingViewModel: OnboardingViewModel = .init(tinggApiServices: BaseRepository())
    var dbTransactionController: DBTransactions = .init()
    let key = KeyEquivalent("p")
    @Environment(\.openURL) var openURL
    @EnvironmentObject var navigation: NavigationUtils
    public init() {}
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .top) {
                    topRectangleBackground(geometry: geometry)
                    topCameraImage(geometry: geometry)
                }
                .frame(width: geometry.size.width, height: abs(geometry.size.height * 0.25))
                MobileNumberView()
                CountryCodesView(
                    phoneNumber: $onboardingViewModel.phoneNumber,
                    countryCode: $onboardingViewModel.countryCode,
                    countries: $onboardingViewModel.countryDictionary)
                    .countryFieldViewStyle(
                        CountryViewDropDownStyle(
                            isValidPhoneNumber: $onboardingViewModel.isValidPhoneNumber
                        )
                    )
                    .onChange(of: onboardingViewModel.phoneNumber) { number in
                        onboardingViewModel.verifyPhoneNumber(number: number)
                    }
                VerificationCodeAdviceTextView()
                PolicySectionView()
                    .environmentObject(onboardingViewModel)
                Spacer()
                TinggSupportSectionView(geometry: geometry)
                    .environmentObject(onboardingViewModel)
                SubmitButtonView()
                    .environmentObject(onboardingViewModel)
                
            }
            .alert(onboardingViewModel.warning, isPresented: $onboardingViewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Contact", isPresented: $onboardingViewModel.showSupportTeamContact) {
                Button("Call Ting Support") {
                    callSupport()
                }
                Button("Chat Ting Support") {
                    print("Chat")
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Support")
            }
            .sheet(isPresented: $onboardingViewModel.showOTPView, onDismiss: {
                if onboardingViewModel.confirmedOTP {
                    onboardingViewModel.retainActiveCountry(
                        country: onboardingViewModel.currentCountry.country!
                    )
                    onboardingViewModel.makePARRequest(
                        msisdn: $onboardingViewModel.phoneNumber.wrappedValue,
                        clientId: $onboardingViewModel.currentCountry.wrappedValue.mulaClientID!
                    )
                }
            }, content: {
                OtpConfirmationView(
                    activeCountry: $onboardingViewModel.currentCountry,
                    phoneNumber: $onboardingViewModel.phoneNumber,
                    otpConfirmed: $onboardingViewModel.confirmedOTP
                )
            })
            .background(PrimaryTheme.getColor(.tinggwhite))
            .handleViewState(uiModel: $onboardingViewModel.uiModel)
            .onAppear {
                onboardingViewModel.observeUIModel { data in
                    confirmRegistration(data: data)
                }
            }
        }
    }
    fileprivate func callSupport() {
        let tel = "tel://"
        let supportNumber = "+254708802299"
        let formattedPhoneNumber = tel+supportNumber
        guard let url = URL(string: formattedPhoneNumber) else {return}
        openURL(url)
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
            $onboardingViewModel.showOTPView.wrappedValue = true
        } else {
            $onboardingViewModel.showOTPView.wrappedValue = true
        }
        if !onboardingViewModel.showOTPView && onboardingViewModel.confirmedOTP {
            if let parResponse = data as? PARAndFSUDTO {
                Task {
                    let sortedCategories = parResponse.categories.sorted { category1, category2 in
                        Int(category1.categoryOrderID!)! < Int(category2.categoryOrderID!)!
                    }.filter { category in
                        category.activeStatus == "1"
                    }
                    onboardingViewModel.saveObjects(data: sortedCategories)
                    onboardingViewModel.saveObjects(data: parResponse.services)
                    let profile = parResponse.mulaProfileInfo.mulaProfile[0]
                    onboardingViewModel.save(data: profile)
                    navigation.screen = .home
                }
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
        Task {
            guard let country = await fetchCountries.getCountryByDialCode(dialCode: countryCode) else {
                printLn(methodName: "getSelectedCountryRegex", message: "country is nil")
                return
            }
            currentCountry = country
        }
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

    func retainActiveCountry(country: String) {
        AppStorageManager.retainActiveCountry(country: country)
    }
}
