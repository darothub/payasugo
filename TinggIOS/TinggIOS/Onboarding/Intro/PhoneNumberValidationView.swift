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
   var theme = PrimaryTheme()
    @State var phoneNumber = ""
    @State var countryCode = "267"
    @State var isEditing = false
    @State var isCheckedTermsAndPolicy = false
    @State var showSupportTeamContact = false
    @State var country: Country = Country()
    @State var isValidPhoneNumber = true
    @State var showTermsAndPolicyAlert = false
    @StateObject var fetchCountries: FetchCountries = FetchCountries()
    @StateObject var getActivationCode: GetActivationCode = GetActivationCode()
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
                CountryCodesView(phoneNumber: $phoneNumber, countryCode: $countryCode)
                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                            .foregroundColor(theme.cellulantRed)
                    )
                    .padding(.horizontal, theme.largePadding)
                    .someShadow(showShadow: $isValidPhoneNumber)
                    .onReceive(Just(phoneNumber)) { number in
                        let phoneNumber = "+\(countryCode)\(number)"
                        let regex = getSelectedCountryRegex()
                        guard validatePhoneNumberWith(regex: regex, phoneNumber: phoneNumber) != nil else {
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
                }.padding(.horizontal, 50)
                .frame(width: geometry.size.width)
                NavigationLink(destination: IntroView(), isActive: $isEditing) {
                    UtilViews.button(backgroundColor: theme.primaryColor, buttonLabel: "Continue") {
                        let fullPhoneNumber = "+\(countryCode)\(phoneNumber)"
                        print("Phone \(fullPhoneNumber)")
                        if !isCheckedTermsAndPolicy {
                            showTermsAndPolicyAlert.toggle()
                            return
                        }
                        var request = TinggRequest()
                        request.change(service: "MAK", msisdn: fullPhoneNumber, clientId: self.country.mulaClientID!)
                        print("Request \(request)")
                        getActivationCode.getCode(activationCodeRequest: request) { result in
                            print("Result \(result)")
                        }
                    }
                }
            }.alert(termsAndConditionWarning, isPresented: $showTermsAndPolicyAlert) {
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
}
