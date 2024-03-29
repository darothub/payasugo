//  HomeViewModel.swift
//  Created by Abdulrasaq on 24/07/2022.
import Checkout
import Combine
import Contacts
import Core
import CoreUI
import Foundation
import Permissions
import SwiftUI
@MainActor
public class HomeViewModel: ViewModel {
    @Published var defaultNetworkServiceId: Int? = AppStorageManager.getDefaultNetworkId()
    @Published public var fetchBillUIModel = UIModel.nothing
    @Published public var quickTopUIModel = UIModel.nothing
    @Published public var categoryUIModel = UIModel.nothing
    @Published public var uiModel = UIModel.nothing
    @Published var photoUploadUIModel = UIModel.nothing
    @Published var billReminderUIModel = UIModel.nothing
    @Published var defaultNetworkUIModel = UIModel.nothing
    @Published var selectedDefaultNetworkName = ""
    @Published var permission = ContactManager()
    @Published var country = AppStorageManager.getCountry()
    @Published var sections: [TransactionSectionModel] = [.sample, .sample2]

    var subscriptions = Set<AnyCancellable>()
    var baseRequest: TinggApiServices = BaseRequest()
    var realmManager: RealmManager = .init()
    private var profileRepository: ProfileRepository
    private var merchantRepository: MerchantServiceRepository
    private var chunkedCategoriesUsecase: ChunkedCategoriesUsecase
    private var updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase
    private var systemUpdateUsecase: SystemUpdateUsecase
    
    /// ``HomeViewModel`` initialiser
    /// - Parameters:
    ///   - profileRepository: ``ProfileRepositoryImpl``
    ///   - merchantRepository: ``MerchantServiceRepositoryImpl``
    ///   - chunkedCategoriesUsecase: ``ChunkedCategoriesUsecase``
    ///   - updateDefaultNetworkIdUsecase: ``UpdateDefaultNetworkUsecase``
    ///   - systemUpdateUsecase: ``SystemUpdateUsecase``
    public init(
        profileRepository: ProfileRepository,
        merchantRepository: MerchantServiceRepository,
        chunkedCategoriesUsecase: ChunkedCategoriesUsecase,
        updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase,
        systemUpdateUsecase: SystemUpdateUsecase

    ) {
        self.profileRepository = profileRepository
        self.merchantRepository = merchantRepository
        self.chunkedCategoriesUsecase = chunkedCategoriesUsecase
        self.updateDefaultNetworkIdUsecase = updateDefaultNetworkIdUsecase
        self.systemUpdateUsecase = systemUpdateUsecase
    }

    func fetchSystemUpdate() async {
        let systemUpdateRequest: RequestMap = RequestMap.Builder()
            .add(value: "PAR", for: .SERVICE)
            .build()
        uiModel = UIModel.loading
        do {
            let response = try await systemUpdateUsecase(request: systemUpdateRequest)
            await saveDataIntoDB(data: response)
            handleResultState(model: &uiModel, Result.success(response) as Result<Any, ApiError>)
        } catch {
            handleResultState(model: &uiModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
        }
    }

    /// Save System  update response in database
    func saveDataIntoDB(data: SystemUpdateDTO) async {
        let sortedCategories = data.categories.sorted { category1, category2 in
            category1.categoryID.convertStringToInt() < category2.categoryID.convertStringToInt()
        }.filter { category in
            category.isActive
        }.map { c in
            c.toEntity
        }
        realmManager.save(data: sortedCategories)
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

        realmManager.save(data: services.map { $0.toEntity })
        realmManager.save(data: data.transactionSummaryInfo.map { $0.toEntity })
        let eligibleNomination = data.nominationInfo.filter { nom in
            nom.clientProfileAccountID?.toInt != nil
        }
        let validNomination = eligibleNomination.filter { e in
            !e.isReminder.toBool && e.isActive
        }
        let validEnrollment = validNomination.map { $0.toEntity }
        realmManager.save(data: validEnrollment)
        let profile = data.mulaProfileInfo.mulaProfile[0]
        realmManager.save(data: profile.toEntity)
        realmManager.save(data: data.virtualCards.map { $0.toEntity })
        let payers: [MerchantPayer] = data.merchantPayers.map { $0.toEntity }
        realmManager.save(data: data.securityQuestions.map { $0.toEntity })
        realmManager.save(data: payers)

        realmManager.save(data: data.bundleData.map { $0.toEntity })

        AppStorageManager.retainCountriesExtraInfo(countrExtra: data.countriesExtraInfo)
    }

    public func updateProfile(_ request: RequestMap) {
        uiModel = .loading

        Task {
            do {
                let result = try await profileRepository.updateProfile(request: request)
                handleResultState(model: &uiModel, Result.success(result) as Result<Any, Error>, showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &uiModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }

    public func updateProfileImage(_ request: RequestMap) {
        photoUploadUIModel = .loading

        Task {
            do {
                let result = try await profileRepository.updateProfileImage(request: request)
                handleResultState(model: &photoUploadUIModel, Result.success(result) as Result<Any, Error>, showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &photoUploadUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }

    public func getProfile() -> Profile {
        profileRepository.getProfile()!
    }

    func updateDefaultNetworkId(request: RequestMap) {
        defaultNetworkUIModel = UIModel.loading

        Task {
            do {
                let result = try await updateDefaultNetworkIdUsecase(request: request)
                handleResultState(model: &defaultNetworkUIModel, Result.success(result) as Result<Any, Error>, showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &defaultNetworkUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }
    func handleTermsAndConditionAcceptance(request: RequestMap) {
        uiModel = UIModel.loading
        Task {
            do {
                let result = try await profileRepository.acceptTermsAndCondition(request: request)
                handleResultState(model: &uiModel, Result.success(result) as Result<BaseDTO, Error>, showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &uiModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }
    func updateBillReminder(request: RequestMap) {
        billReminderUIModel = UIModel.loading
        Task {
            do {
                let result = try await updateDefaultNetworkIdUsecase(request: request)
                handleResultState(model: &billReminderUIModel, Result.success(result) as Result<Any, Error>, showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &billReminderUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }

    public func getServicesByCategory() -> [[CategoryDTO]] {
        categoryUIModel = UIModel.loading
        let servicesByCategory = chunkedCategoriesUsecase()
        handleResultState(model: &categoryUIModel, Result.success(servicesByCategory) as Result<Any, Error>)
        return servicesByCategory
    }

    public func getQuickTopups() -> [MerchantService] {
        quickTopUIModel = UIModel.loading
        let quicktopups = merchantRepository.getServices().filter { $0.isAirtimeService }

        handleResultState(model: &quickTopUIModel, Result.success(quicktopups) as Result<Any, Error>)
        return quicktopups
    }

    func getJKSFileUrl() -> URL? {
        let fileURL = Bundle.main.url(forResource: "tingg", withExtension: "jks")
        return fileURL
    }

    func getCryptoKeysFromJKSFile(_ url: URL) async throws -> (privateKey: SecKey, publicKey: SecKey) {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let (privateKey, publicKey) = try TinggSecurity.getKeysFromJKSFile(jksFilePath: url.path, jksPassword: TinggSecurity.JKSPASSWORD, alias: TinggSecurity.JKSALIAS)
                continuation.resume(returning: (privateKey: privateKey, publicKey: publicKey))
            } catch {
                uiModel = UIModel.error(error.localizedDescription)
                continuation.resume(throwing: error)
            }
        }
    }

    func savePrivateKeyAsData(_ data: Data) {
        AppStorageManager.setPrivateKeyData(data)
    }

    func savePublicKeyAsData(_ data: Data) {
        AppStorageManager.setPublicKeyData(data)
    }

    func fetchPhoneContacts(action: @escaping (CNContact) -> Void) async {
        Task {
            await self.permission.fetchContacts { [unowned self] result in
                switch result {
                case let .failure(error):
                    uiModel = UIModel.error(error.localizedDescription)
                case let .success(contacts):
                    action(contacts)
                }
            }
        }
    }

    /// Handle result
    public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>, showAlertOnSuccess: Bool = false) where E: Error {
        switch result {
        case let .failure(apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case let .success(data):
            var content: UIModel.Content
            if let d = data as? BaseDTOprotocol {
                content = UIModel.Content(data: data, statusMessage: d.statusMessage, showAlert: showAlertOnSuccess)
            } else {
                content = UIModel.Content(data: data, showAlert: showAlertOnSuccess)
            }
            model = UIModel.content(content)
            return
        }
    }
}
