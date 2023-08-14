//  OnboardingVM.swift
//  TinggIOS
//  Created by Abdulrasaq on 13/07/2022.
import Combine
import Core
import CoreUI
import Foundation
import RealmSwift
import SwiftUI
@MainActor
public class OnboardingVM: ViewModel {
    let activationUsecase: ActivationCodeUsecase
    let systemUpdateUsecase: SystemUpdateUsecase
    let getCountriesDictionaryUsecase: GetCountriesAndDialCodeUseCase
    @Published var uiModel = UIModel.nothing
    @Published var phoneNumberFieldUIModel = UIModel.nothing
    @Published var onActivationRequestUIModel = UIModel.nothing
    @Published var onConfirmActivationUIModel = UIModel.nothing
    @Published var realmManager: RealmManager = .init()
    @Published var currentCountryDialCode = ""
    @Published var isValidPhoneNumber = false
    @Published var phoneNumber = ""
    @Published var hasCheckedTermsAndPolicy = false
    @Published var activateContinueButton = false
    @Published var currentCountry: CountryInfo = .init()
    @Published var flags = ["🇺🇸 +1", "🇬🇧 +44", "🇨🇦 +1", "🇦🇺 +61", "🇩🇪 +49"]
    @Published var countryFlag = "🇺🇸 +1"
    @Published var termOfAgreementLink = "[Terms of Agreement](https://cellulant.io)"
    @Published var privacyPolicy = "[Privacy Policy](https://cellulant.io)"
    private static var policyWarning = "Kindly accept terms and policy"
    private static var phoneNumberIsEmptyWarning = "Phone number must not be empty"
    private static var invalidPhoneNumber = "Invalid phone number"
    var subscriptions = Set<AnyCancellable>()
    public init(
        activationUsecase: ActivationCodeUsecase,
        systemUpdateUsecase: SystemUpdateUsecase,
        getCountriesDictionaryUsecase: GetCountriesAndDialCodeUseCase
    ) {
        self.activationUsecase = activationUsecase
        self.systemUpdateUsecase = systemUpdateUsecase
        self.getCountriesDictionaryUsecase = getCountriesDictionaryUsecase
    }

    /// Collect a dictionary of country code and dial code
    func getCountryDictionary() {
        phoneNumberFieldUIModel = UIModel.loading
        Task {
            do {
                let result = try await getCountriesDictionaryUsecase()
                handleResultState(model: &phoneNumberFieldUIModel, Result.success(result) as Result<[String: String], ApiError>)
            } catch {
                handleResultState(model: &phoneNumberFieldUIModel, Result.failure(error as! ApiError) as Result<BaseDTO, ApiError>)
            }
        }
    }

    /// Request for activation code
    func getActivationCode(request: RequestMap) {
        onActivationRequestUIModel = UIModel.loading
        Task {
            do {
                let result = try await activationUsecase(request: request)
                handleResultState(model: &onActivationRequestUIModel, Result.success(result) as Result<BaseDTO, ApiError>)
            } catch {
                handleResultState(model: &onActivationRequestUIModel, Result.failure(error as! ApiError) as Result<BaseDTO, ApiError>)
            }
        }
    }
    

    /// Request for confirmation of  OTP
    func confirmActivationCode(otp: String) {
        onConfirmActivationUIModel = UIModel.loading
        let confirmOTPRequest: RequestMap = RequestMap.Builder()
            .add(value: "VAK", for: .SERVICE)
            .add(value: otp, for: .ACTIVATION_CODE)
            .build()
        
        Task {
            do {
                let response = try await activationUsecase(request: confirmOTPRequest)
                handleResultState(model: &onConfirmActivationUIModel, Result.success(response) as Result<BaseDTO, ApiError>)
            } catch {
                handleResultState(model: &onConfirmActivationUIModel, Result.failure(error as! ApiError) as Result<BaseDTO, ApiError>)
            }
        }
    }

    /// Request for System update FSU

    func fetchSystemUpdate() {
        let systemUpdateRequest: RequestMap = RequestMap.Builder()
            .add(value: "PAR", for: .SERVICE)
            .build()
        uiModel = UIModel.loading
        Task {
            do {
                let response = try await systemUpdateUsecase(request: systemUpdateRequest)
                saveDataIntoDB(data: response)
                handleResultState(model: &uiModel, Result.success(response) as Result<Any, ApiError>)
            } catch {
                let err = error as! ApiError
                handleResultState(model: &uiModel, Result.failure(err) as Result<BaseDTO, ApiError>)
            }
        }
    }

    func validatePhoneNumberInput(_ number: String, _ countryDialCode: String) -> Bool {
        var result = false
        if let regex = getSelectedCountryRegexByDialcode(dialCode: countryDialCode) {
            result = checkStringForPatterns(inputString: number, pattern: regex)
        }
        if number.count < 8 {
            result = false
        }
        DispatchQueue.main.async {
            self.isValidPhoneNumber = result
        }
        return result
    }

    func getSelectedCountryRegexByDialcode(dialCode: String) -> String? {
        if let country = getCountryByDialCode(dialCode: dialCode) {
            return country.countryMobileRegex
        }
        return nil
    }

    func getCountryByDialCode(dialCode: String) -> CountriesInfoDTO? {
        if let country = getCountriesDictionaryUsecase(dialCode: dialCode) {
            return country
        }
        return nil
    }

    func otpRequest() {
        let activationCodeRequest: RequestMap = RequestMap.Builder()
            .add(value: "MAK", for: .SERVICE)
            .build()
        let encrypted = activationCodeRequest.encryptPayload()
        Log.d(message: "\(String(describing: encrypted))")
        getActivationCode(request: activationCodeRequest)
    }

    func prepareActivationRequest() {
        let number = "\(currentCountryDialCode)\(phoneNumber)"
        AppStorageManager.retainPhoneNumber(number: number)
        if let country = getCountryByDialCode(dialCode: currentCountryDialCode) {
            Log.d(message: "\(country)")
            AppStorageManager.retainActiveCountry(country: country)
            otpRequest()
        }
       
    }

    /// Save System  update response in database
    private func saveDataIntoDB(data: SystemUpdateDTO) {
        let categoriesTable = Observer<CategoryEntity>()
        let servicesTable = Observer<MerchantService>()
        let enrollmentsTable = Observer<Enrollment>()
        let cardsTable = Observer<Card>()
        let profileTable = Observer<Profile>()
        let securityQuestionTable = Observer<SecurityQuestion>()
        let merchantPayerTable = Observer<MerchantPayer>()
        let transactioSummaryTable = Observer<TransactionHistory>()
        let formParameterClassTable = Observer<FORMPARAMETERSClassEntity>()
        let formParameterTable = Observer<FormParameterEntity>()
        let itemTable = Observer<ItemEntity>()
        let serviceParametersTable = Observer<ServiceParametersEntity>()
        let servicesDatumTable = Observer<ServicesDatumEntity>()
        let sortedCategories = data.categories.sorted { category1, category2 in
            category1.categoryID.convertStringToInt() < category2.categoryID.convertStringToInt()
        }.filter { category in
            category.isActive
        }.map { c in
            c.toEntity
        }
        categoriesTable.clearAndSaveEntities(objs: sortedCategories)
        realmManager.save(data: data.contactInfo.map { $0.toEntity })
        let services = data.services.filter { service in
            service.isActive
        }
        if let defaultNetworkServiceId = data.defaultNetworkServiceID {
            AppStorageManager.setDefaultNetworkId(id: defaultNetworkServiceId)
            let defaultNetwork = services.first { s in
                s.hubServiceID.convertStringToInt() == defaultNetworkServiceId
            }

            if let service = defaultNetwork {
                AppStorageManager.setDefaultNetwork(service: service.toEntity)
            }
        }

        itemTable.deleteEntries()
        formParameterTable.deleteEntries()
        formParameterClassTable.deleteEntries()
        servicesDatumTable.deleteEntries()
        serviceParametersTable.deleteEntries()
        servicesTable.clearAndSaveEntities(objs: services.map { $0.toEntity })
        transactioSummaryTable.clearAndSaveEntities(objs: data.transactionSummaryInfo.map { $0.toEntity })
        let eligibleNomination = data.nominationInfo.filter { nom in
            nom.clientProfileAccountID?.toInt != nil
        }
        let validNomination = eligibleNomination.filter { e in
            !e.isReminder.toBool && e.isActive
        }
        let validEnrollment = validNomination.map { $0.toEntity }
        enrollmentsTable.clearAndSaveEntities(objs: validEnrollment)
        let profile = data.mulaProfileInfo.mulaProfile[0]
        profileTable.clearAndSaveEntity(obj: profile.toEntity)
        Observer<BundleData>().getEntities().forEach { data in
            realmManager.delete(data: data)
        }
        Observer<BundleObject>().getEntities().forEach { data in
            realmManager.delete(data: data)
        }
        cardsTable.clearAndSaveEntities(objs: data.cardDetails)
        let payers: [MerchantPayer] = data.merchantPayers.map { $0.toEntity }
        securityQuestionTable.clearAndSaveEntities(objs: data.securityQuestions.map { $0.toEntity })
        merchantPayerTable.clearAndSaveEntities(objs: payers)

        realmManager.save(data: data.bundleData.map { $0.toEntity })

        AppStorageManager.retainCountriesExtraInfo(countrExtra: data.countriesExtraInfo)
    }

    /// Handle Result
    public func handleResultState<T, E>(model: inout CoreUI.UIModel, _ result: Result<T, E>) where E: Error {
        switch result {
        case let .failure(apiError):
            Log.d(message: "\(apiError)")
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case let .success(data):
            let dto = data as? BaseDTO
            if let statusCode = dto?.statusCode {
                if statusCode > 201 {
                    model = UIModel.error(dto?.statusMessage ?? "")
                    return
                }
            }
            let content = UIModel.Content(data: data)
            model = UIModel.content(content)
            return
        }
    }
}
