//  OnboardingVM.swift
//  TinggIOS
//  Created by Abdulrasaq on 13/07/2022.
import Combine
import CoreUI
import Core
import Foundation
import SwiftUI
import RealmSwift
public class OnboardingVM: ViewModel {
    let activationUsecase: ActivationCodeUsecase
    let systemUpdateUsecase: SystemUpdateUsecase
    let getCountriesDictionaryUsecase: GetCountriesAndDialCodeUseCase
    @Published var uiModel = UIModel.nothing
    @Published var phoneNumberFieldUIModel = UIModel.loading
    @Published var onActivationRequestUIModel = UIModel.nothing
    @Published var onConfirmActivationUIModel = UIModel.nothing
    @Published var realmManager: RealmManager = .init()
    public init(activationUsecase: ActivationCodeUsecase, systemUpdateUsecase: SystemUpdateUsecase, getCountriesDictionaryUsecase: GetCountriesAndDialCodeUseCase) {
        self.activationUsecase = activationUsecase
        self.systemUpdateUsecase = systemUpdateUsecase
        self.getCountriesDictionaryUsecase = getCountriesDictionaryUsecase
        self.uiModel = uiModel
    }
    /// Collect a dictionary of country code and dial code
    @MainActor
    func getCountryDictionary() {
        phoneNumberFieldUIModel = UIModel.loading
        Task {
            do {
                let result = try await getCountriesDictionaryUsecase()
                handleResultState(model: &phoneNumberFieldUIModel, Result.success(result) as Result<[String: String], ApiError>)
            } catch {
                handleResultState(model: &uiModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
            }
        }
    }
    /// Request for activation code
    @MainActor
    func getActivationCode(request: RequestMap) {
        onActivationRequestUIModel = UIModel.loading
        Task {
            do {
                let result = try await activationUsecase(request: request)
                handleResultState(model: &onActivationRequestUIModel, result)
            } catch {
                handleResultState(model: &onActivationRequestUIModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
            }
        }
    }
    /// Request for confirmation of  OTP
    @MainActor
    func confirmActivationCode(request: RequestMap) {
        onConfirmActivationUIModel = UIModel.loading
        Task {
            do {
                let response = try await activationUsecase(request: request)
                handleResultState(model: &onConfirmActivationUIModel, response)
            } catch {
                handleResultState(model: &onConfirmActivationUIModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
            }
        }
    }
    /// Request for System update FSU
    @MainActor
    func fetchSystemUpdate(request: RequestMap) {
        uiModel = UIModel.loading
        Task {
            do {
                let response = try await systemUpdateUsecase(request: request)
                handleResultState(model: &uiModel, response)
            } catch {
                handleResultState(model: &uiModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
            }
        }
    }
    @MainActor
    func getCountryByDialCode(dialCode: String) -> Country? {
        if let country = getCountriesDictionaryUsecase(dialCode: dialCode) {
            return country
        }
        return nil
    }
    /// Save System  update response in database
    func saveDataIntoDB(data: SystemUpdateDTO)  {
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
        realmManager.save(data: data.contactInfo.map {$0.toEntity})
        let services = data.services.filter { service in
            service.isActive
        }
        if let defaultNetworkServiceId = data.defaultNetworkServiceID {
            AppStorageManager.setDefaultNetworkId(id: defaultNetworkServiceId)
            let defaultNetwork = services.first { s in
                Log.d(message: "default \(defaultNetworkServiceId) \(s.hubServiceID.toInt)")
                return s.hubServiceID.toInt == defaultNetworkServiceId
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
      
        AppStorageManager.retainCountriesExtraInfo(countrExtra: data.countriesExtraInfo)
    }
    /// Handle Result
    public func handleResultState<T, E>(model: inout CoreUI.UIModel, _ result: Result<T, E>) where E : Error {
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
    
}



