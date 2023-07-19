//
//  PhoneNumberValidationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//  swiftlint:disable all

import Combine
import Core
import CoreNavigation
import CoreUI
import FreshChat
import SwiftUI
import Theme
/// The view for phone number input and validation
/// User can also have access to support features
/// Upon successful input validation user is taken to ``OtpConfirmationView``
/// User is directed to the Home view after OTP confirmation
public struct PhoneNumberValidationView: View {
    @StateObject var ovm = OnboardingDI.createOnboardingVM()
    @Environment(\.openURL) var openURL
    @EnvironmentObject var navigation: NavigationManager
    @EnvironmentObject private var freshchatWrapper: FreshchatWrapper
    @State private var showOTPView = false
    @State private var showSupportTeamContact = false
    @State private var activateButton = false
    @FocusState private var isFocused: Bool
    private let dbCountries = Observer<CountryInfo>().getEntities()

    public init() {
        // Empty constructor
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                topView(geo: geometry)
                Section {
                    MobileNumberView()
                    FlagTextField(phoneNumber: $ovm.phoneNumber, flags: $ovm.flags, selectedFlag: $ovm.countryFlag) { text in
                        ovm.validatePhoneNumberInput(text, ovm.currentCountryDialCode)
                    }
                    .focused($isFocused, equals: ovm.isValidPhoneNumber)
                    VerificationCodeAdviceTextView()
                    PolicySectionView(
                        termOfAgreementLink: $ovm.termOfAgreementLink,
                        privacyPolicy: $ovm.privacyPolicy,
                        hasCheckedTermsAndPolicy: $ovm.hasCheckedTermsAndPolicy
                    ).focused($isFocused, equals: ovm.hasCheckedTermsAndPolicy)
                    Spacer()
                    TinggSupportSectionView(showSupportTeamContact: $showSupportTeamContact)
                    TinggButton(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Continue",
                        isActive: $activateButton
                    ) {
                        ovm.prepareActivationRequest()
                    }
                    .accessibility(identifier: "continuebtn")
                }.padding(.horizontal)
            }
            .background(.white)
            .onAppear {
                ovm.getCountryDictionary()
                Publishers.CombineLatest(ovm.$isValidPhoneNumber, ovm.$hasCheckedTermsAndPolicy)
                    .sink { isValidPhoneNumber, hasCheckedTermsAndPolicy in
                        activateButton = isValidPhoneNumber && hasCheckedTermsAndPolicy
                    }.store(in: &ovm.subscriptions)
            }
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Contact", isPresented: $showSupportTeamContact) {
                callSupportActions()
            } message: {
                Text("Support")
            }
            .sheet(isPresented: $showOTPView, content: {
                OtpConfirmationView()
                    .environmentObject(navigation)
            })
            .onChange(of: ovm.countryFlag, perform: { newValue in
                let dialCode = newValue.split(separator: " ")[1]
                ovm.currentCountryDialCode = String(dialCode.dropFirst())
                let currentCountry = dbCountries.first {
                    $0.countryDialCode == ovm.currentCountryDialCode
                }
                if let country = currentCountry {
                    ovm.termOfAgreementLink = "[Terms of Agreement](\(String(describing: country.tacURL)))"
                    ovm.privacyPolicy = "[Privacy Policy](\(String(describing: country.privacyPolicyURL)))"

                    _ = FreshChatSetup(appID: country.freshchatAppID!, appKey: country.freshchatAppKey!)
                    ovm.currentCountry = country
                }

            })
            .toolbar(content: {
                handleKeyboardDone()
            })
            .handleViewStatesMods(uiState: ovm.$onActivationRequestUIModel) { _ in
                showOTPView = true
            }
            .handleViewStatesMods(uiState: ovm.$phoneNumberFieldUIModel) { content in
                let countriesDictionary = content.data as! [String: String]
                DispatchQueue.main.async {
                    ovm.flags = countriesDictionary.sorted(by: <).map({ key, value in
                        let flag = getFlag(country: key)
                        return "\(flag) +\(value)"
                    })
                    if ovm.flags.isNotEmpty() && ovm.countryFlag == "🇺🇸 +1" {
                        ovm.countryFlag = ovm.flags.first!
                    }
                }
            }
        }
        .onDisappear {
            ovm.phoneNumberFieldUIModel = UIModel.nothing
            ovm.onActivationRequestUIModel = UIModel.nothing
        }
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
        VStack {
            Rectangle()
                .fill(PrimaryTheme.getColor(.cellulantLightGray))
                .edgesIgnoringSafeArea(.all)
        }
        .frame(width: geo.size.width, height: abs(geo.size.height * 0.25))
    }

    @ViewBuilder
    fileprivate func callSupportActions() -> some View {
        Button("Call Ting Support") {
            Core.callSupport(phoneNumber: "254708802299")
        }
        Button("Chat Ting Support") {
            freshchatWrapper.showFreshchat()
        }
        Button("Cancel", role: .cancel) {
            // Intentionally unimplemented...no cancel action
        }
    }

    fileprivate func handleKeyboardDone() -> ToolbarItemGroup<TupleView<(Spacer, Button<Text>)>> {
        return ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") {
                isFocused = false
            }
        }
    }

    fileprivate func callSupport() {
        let tel = "tel://"
        let supportNumber = "+254708802299"
        let formattedPhoneNumber = tel + supportNumber
        guard let url = URL(string: formattedPhoneNumber) else { return }
        openURL(url)
    }
}

struct PhoneNumberValidationView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberValidationView()
            .environmentObject(FreshchatWrapper())
    }
}
