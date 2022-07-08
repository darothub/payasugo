//
//  PhoneNumberValidationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//

import ApiModule
import Combine
import Core
import Domain
import SwiftUI
import Theme

struct PhoneNumberValidationView: View {
    var theme: PrimaryTheme = .init()
    @State var phoneNumber = ""
    @State var countryCode = "267"
    @State var isEditing = false
    @State var isCheckedTermsAndPolicy = false
    @State var showSupportTeamContact = false
    @State var showOTPView = false
    @State var country: Country = .init()
    @State var isValidPhoneNumber = false
    @State var showAlert = false
    @State var countries: [String: String] = [String: String]()
    @StateObject var fetchCountries: FetchCountries = .init()
    @StateObject var getActivationCode: GetActivationCode = .init()
    let termOfAgreementLink = "[Terms of Agreement](https://cellulant.io)"
    let privacyPolicy = "[Privacy Policy](https://cellulant.io)"
    let termsAndConditionWarning = "You must accept terms of use and privacy policy to proceed!"
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .top) {
                    topRectangleBackground(geometry: geometry)
                    topCameraImage(geometry: geometry)
                }
                .frame(width: geometry.size.width, height: abs(geometry.size.height * 0.25))
                Text("Mobile Number")
                    .bold()
                    .padding(.leading, theme.largePadding)
                CountryCodesView(phoneNumber: $phoneNumber, countryCode: $countryCode, countries: $countries)
                    .countryFieldViewStyle(CountryViewDropDownStyle(theme: theme,
                                                                    isValidPhoneNumber: $isValidPhoneNumber))
                    .onChange(of: phoneNumber) { number in
                        let phoneNumber = "+\(countryCode)\(number)"
                        let regex = getSelectedCountryRegex()
                        guard validatePhoneNumberWith(regex: regex, phoneNumber: phoneNumber) != nil
                        else {
                            isValidPhoneNumber = false
                            return
                        }
                        if number.count < 8 {
                            isValidPhoneNumber = false
                            return
                        }
                        isValidPhoneNumber = true
                    }
                Text("We'll send verification code to this number")
                    .bold()
                    .padding(.leading, theme.largePadding)
                HStack(alignment: .top) {
                    Group {
                        CheckBoxView(checkboxChecked: $isCheckedTermsAndPolicy)
                        Text("By proceeding you agree with the ")
                        + Text(.init(termOfAgreementLink))
                            .underline()
                        + Text(" and ") + Text(.init(privacyPolicy)).underline()
                    }.font(.system(size: theme.smallTextSize))
                }
                .padding(.horizontal, theme.largePadding)
                Spacer()
                Button {
                    showSupportTeamContact.toggle()
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "phone.circle.fill")
                            .foregroundColor(Color.green)
                        Text("CONTACT TINGG SUPPORT TEAM")
                    }
                    .frame(width: geometry.size.width)
                    .font(.system(size: theme.smallTextSize))
                }.padding(.horizontal, 50)
                .frame(width: geometry.size.width)
                NavigationLink(destination: IntroView(), isActive: $isEditing) {
                    UtilViews.button(backgroundColor: theme.primaryColor, buttonLabel: "Continue") {
                        let fullPhoneNumber = "+\(countryCode)\(phoneNumber)"
                        if !isCheckedTermsAndPolicy {
                            showAlert.toggle()
                            return
                        }
                        makeActivationCodeRequest(fullPhoneNumber)
                    }
                }
            }.task {
                getCountries()
            }
            .alert(termsAndConditionWarning, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            .navigationBarTitleDisplayMode(.inline)
            .popover(isPresented: $showSupportTeamContact) {
                VStack {
                    Text("Call Ting Support")
                        .padding()
                    Text("Chat Ting Support")
                        .padding()
                }
            }
            .popover(isPresented: $showOTPView) {
                OtpConfirmationView()
            }
            .environmentObject(fetchCountries)
        }
    }
    func getSelectedCountryRegex() -> String {
        let data = fetchCountries.$countriesDb.wrappedValue
        let country = data.first { country in
            country.countryDialCode == self.countryCode
        }
        if let currentCountry = country {
            self.country = currentCountry
        }
        guard let regex = country?.countryMobileRegex else { return ""}
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
    fileprivate func makeActivationCodeRequest(_ fullPhoneNumber: String) {
        var request = TinggRequest()
        request.change(service: "MAK", msisdn: fullPhoneNumber, clientId: self.country.mulaClientID!)
        Task {
            getActivationCode.getCode(activationCodeRequest: request) { result in
                if result is Error {
                    print("ResultError \(result)")
                    return
                }
                showOTPView = true
            }
        }
    }
}

struct PhoneNumberValidationView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberValidationView()
            .environmentObject(FetchCountries())
            .environmentObject(GetActivationCode())
    }
}

extension PhoneNumberValidationView {
    fileprivate func topRectangleBackground(geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(theme.lightGray)
            .frame(width: geometry.size.width, height: abs(geometry.size.height * 1.4 * 0.25))
            .edgesIgnoringSafeArea(.all)
    }
    fileprivate func topCameraImage(geometry: GeometryProxy) -> some View {
        Image(systemName: "camera.fill")
            .frame(width: geometry.size.width * 0.21,
                   height: geometry.size.height * 0.1,
                   alignment: .center)
            .scaleEffect(1.5)
            .foregroundColor(theme.cellulantRed)
            .background(.white)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .shadow(radius: 3)
            .padding(.bottom, 10)
            .alignmentGuide(VerticalAlignment.top) { align in
                -align[VerticalAlignment.center] * 0.5
            }
    }
    func getCountries() {
        countries = self.fetchCountries.$countriesDb.wrappedValue.reduce(into: [:]) { partialResult, country in
            partialResult[country.countryCode!] = country.countryDialCode
        }
    }
}
