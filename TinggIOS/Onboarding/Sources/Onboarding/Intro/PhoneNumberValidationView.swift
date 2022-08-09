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
    @State var phoneNumber = ""
    @State var countryCode = "267"
    @State var countries: [String: String] = [String: String]()
    // swiftlint:disable all
    @StateObject var vm = OnboardingViewModel(
        countryRepository: CountryRepositoryImpl(
            apiService: BaseRepository(),
            realmManager: RealmManager()),
        baseRequest: BaseRequest(apiServices: BaseRepository())
    )
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
                }
                .frame(width: geometry.size.width, height: abs(geometry.size.height * 0.25))
                MobileNumberView()
                CountryCodesView(phoneNumber: $vm.phoneNumber, countryCode: $vm.countryCode, countries: $vm.countryDictionary)
                    .countryFieldViewStyle(
                        CountryViewDropDownStyle(
                            isValidPhoneNumber: $vm.isValidPhoneNumber
                        )
                    )
                    .onChange(of: vm.phoneNumber) { number in
                        vm.verifyPhoneNumber(number: number)
                    }
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
                Button("OK", role: .cancel) { }
                    .accessibility(identifier: "warningbutton")
            }
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Contact", isPresented: $vm.showSupportTeamContact) {
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
            .sheet(isPresented: $vm.showOTPView, onDismiss: {
                if vm.confirmedOTP {
                    vm.retainActiveCountry(
                        country: vm.currentCountry.country!
                    )
                    vm.makePARRequest(
                        msisdn: $vm.phoneNumber.wrappedValue,
                        clientId: $vm.currentCountry.wrappedValue.mulaClientID!
                    )
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
                vm.observeUIModel { data in
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
        if !vm.showOTPView && vm.confirmedOTP {
            if let parResponse = data as? PARAndFSUDTO {
                Task {
                    let sortedCategories = parResponse.categories.sorted { category1, category2 in
                        Int(category1.categoryOrderID!)! < Int(category2.categoryOrderID!)!
                    }.filter { category in
                        category.activeStatus == "1"
                    }
                    vm.saveObjects(data: sortedCategories)
                    vm.saveObjects(data: parResponse.services)
                    let profile = parResponse.mulaProfileInfo.mulaProfile[0]
                    vm.save(data: profile)
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
            guard let country = await countryRepository.getCountryByDialCode(dialCode: countryCode) else {
                printLn(methodName: "getSelectedCountryRegex", message: "country is nil")
                return
            }
            DispatchQueue.main.async {
                self.currentCountry = country
            }
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
