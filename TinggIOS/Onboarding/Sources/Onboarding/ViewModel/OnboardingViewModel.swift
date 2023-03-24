//  OnboardingViewModel.swift
//  TinggIOS
//  Created by Abdulrasaq on 13/07/2022.
import Combine
import CoreUI
import Core
import Foundation
import SwiftUI
import RealmSwift
@MainActor
/// Onboarding view model
/// It connects the views to the usecases and repositories
/// It manages the data and UI state of the ``IntroView``
public class OnboardingViewModel: ViewModel {
    @Published var phoneNumber = ""
    @Published var countryCode = ""
    @Published var countryFlag = ""
    @Published var showLoader = false
    @Published var showOTPView = false
    @Published var showError = false
    @Published var navigate = false
    @Published var currentCountry: Country = .init()
    @Published var isValidPhoneNumber = false
    @Published var isCheckedTermsAndPolicy = false
    @Published var showAlert = false
    @Published var confirmedOTP = false
    @Published var showSupportTeamContact = false
    @Published var message = ""
    @Published var warning = ""
    @Published var statusCode = 0
    @Published var phoneNumberFieldUIModel = UIModel.nothing
    @Published var onSubmitUIModel = UIModel.nothing
    @Published var onParRequestUIModel = UIModel.nothing
    @Published var onActivationRequestUIModel = UIModel.nothing
    @Published var onConfirmActivationUIModel = UIModel.nothing
    @Published var uiModel = UIModel.nothing
    @Published public var subscriptions = Set<AnyCancellable>()
    @Published public var countryDictionary = [String: String]()
    @Published var realmManager: RealmManager = .init()
    var onboardingUseCase: OnboardingUseCase
    var name = "OnboardingViewModel"
    
    public init(onboardingUseCase: OnboardingUseCase) {
        self.onboardingUseCase = onboardingUseCase
        getCountryDictionary()
    }
    /// Request for activation code
    func makeActivationCodeRequest() {
        onActivationRequestUIModel = UIModel.loading
        Task {
            do {
                let tinggRequest: RequestMap = RequestMap.Builder()
                    .add(value: "MAK", for: .SERVICE)
                    .build()
                let result = try await onboardingUseCase.makeActivationCodeRequest(tinggRequest: tinggRequest)
                handleResultState(model: &onActivationRequestUIModel, result)
            } catch {
                handleResultState(model: &onActivationRequestUIModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
            }
        }
    }
    /// Confirm activation code
    func confirmActivationCodeRequest(code: String) {
        onConfirmActivationUIModel = UIModel.loading
        Task {
            do {
                let tinggRequest: RequestMap =  RequestMap.Builder()
                    .add(value: "VAK", for: .SERVICE)
                    .add(value: code, for: .ACTIVATION_CODE)
                    .build()
                let result = try await onboardingUseCase.confirmActivationCodeRequest(tinggRequest: tinggRequest, code: code)
                handleResultState(model: &onConfirmActivationUIModel, result)
            } catch {
                handleResultState(model: &onConfirmActivationUIModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
            }
        }
    }
    /// Request for PARandFSU
    func makePARRequest() {
        onParRequestUIModel = UIModel.loading
        Task {
            do {
                let tinggRequest: RequestMap =  RequestMap.Builder()
                    .add(value: "PAR", for: .SERVICE)
                    .build()
                let result = try await onboardingUseCase.makePARRequest(tinggRequest: tinggRequest)
                await saveDataIntoDB(data: try result.get())
                handleResultState(model: &onParRequestUIModel, result)
            } catch {
                handleResultState(model: &onParRequestUIModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
            }
        }
    }
    /// Collect a dictionary of country code and dial code
    func getCountryDictionary() {
        phoneNumberFieldUIModel = UIModel.loading
        Task {
            do {
                countryDictionary = try await onboardingUseCase.getCountryDictionary()
                phoneNumberFieldUIModel = UIModel.nothing
            } catch {
                handleResultState(model: &phoneNumberFieldUIModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
            }
        }
    }
    /// Get a  country by code
    func getCountryByDialCode(dialCode: String) -> Country? {
        Task {
            do {
                guard let country = try await onboardingUseCase.getCountryByDialCode(dialCode: dialCode) else {
                    throw "Invalid dialcode \(dialCode)"
                }
                currentCountry = country
            } catch {
                uiModel = UIModel.error(error.localizedDescription)
            }
        }
        return currentCountry
    }
    func saveDataIntoDB(data: FSUAndPARDTO) async {
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
        
        let services = data.services.filter { service in
            service.isActive
        }
        itemTable.deleteEntries()
        formParameterTable.deleteEntries()
        formParameterClassTable.deleteEntries()
        servicesDatumTable.deleteEntries()
        serviceParametersTable.deleteEntries()
        servicesTable.clearAndSaveEntities(objs: services.map {$0.toEntity})
        transactioSummaryTable.clearAndSaveEntities(objs: data.transactionSummaryInfo.map {$0.toEntity})
        let eligibleNomination = data.nominationInfo.filter { nom in
            nom.clientProfileAccountID?.toInt != nil
        }
        let validNomination = eligibleNomination.filter { e in
            return !e.isReminder.toBool && e.isActive
        }
        let validEnrollment = validNomination.map {$0.toEntity}
        enrollmentsTable.clearAndSaveEntities(objs: validEnrollment)
        let profile = data.mulaProfileInfo.mulaProfile[0]
        profileTable.clearAndSaveEntity(obj: profile.toEntity)
        Observer<BundleData>().getEntities().forEach { data in
            realmManager.delete(data: data)
        }
        Observer<BundleObject>().getEntities().forEach { data in
            realmManager.delete(data: data)
        }
        cardsTable.clearAndSaveEntities(objs: data.virtualCards.map {$0.toEntity})
        let payers: [MerchantPayer] = data.merchantPayers.map {$0.toEntity}
        securityQuestionTable.clearAndSaveEntities(objs: data.securityQuestions.map {$0.toEntity})
        merchantPayerTable.clearAndSaveEntities(objs: payers)

        realmManager.save(data: data.bundleData.map {$0.toEntity})
        if let defaultNetworkServiceId = data.defaultNetworkServiceID {
            AppStorageManager.setDefaultNetworkId(id: defaultNetworkServiceId)
        }
    }
    /// Handle result
    nonisolated public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>) where E : Error {
        switch result {
        case .failure(let apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case .success(let data):
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
    nonisolated public func observeUIModel(model: Published<UIModel>.Publisher, subscriptions: inout Set<AnyCancellable>, action: @escaping (UIModel.Content) -> Void, onError: @escaping(String) -> Void = {_ in}) {
        model.sink { [unowned self] uiModel in
            uiModelCases(uiModel: uiModel, action: action, onError: onError)
        }.store(in: &subscriptions)
    }
}




