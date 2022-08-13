//
//  OnboardingViewModel.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import Combine
import Common
import Core
import Foundation
import SwiftUI
import RealmSwift
public class OnboardingViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var countryCode = "267"
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
    @Published var results = Result<BaseDTOprotocol, ApiError>.failure(.networkError)
    @Published var uiModel = UIModel.nothing
    private var subscriptions = Set<AnyCancellable>()
    private var dbTransaction = DBTransactions()
    @Published public var countryDictionary = [String: String]()
    @Published public var countriesDb = Observer<Country>().objects
    var tinggRequest: TinggRequest = .init()
    var countryRepository: CountryRepositoryImpl
    var baseRequest: BaseRequest
    var name = "OnboardingViewModel"
    public init(countryRepository: CountryRepositoryImpl, baseRequest: BaseRequest) {
        self.countryRepository = countryRepository
        self.baseRequest = baseRequest
        getCountryDictionary()
    }
    func makeActivationCodeRequest(msisdn: String, clientId: String) {
        uiModel = UIModel.loading
        tinggRequest.getActivationCode(service: "MAK", msisdn: msisdn, clientId: clientId)
        baseRequest.makeRequest(tinggRequest: tinggRequest) { [unowned self] (result: Result<BaseDTO, ApiError>) in
            handleResultState(result)
        }
    }
    func confirmActivationCodeRequest(msisdn: String, clientId: String, code: String) {
        uiModel = UIModel.loading
        tinggRequest.confirmActivationCode(
            service: "VAK",
            msisdn: msisdn,
            clientId: clientId,
            code: code
        )
        baseRequest.makeRequest(tinggRequest: tinggRequest) { [unowned self] (result: Result<BaseDTO, ApiError>) in
            handleResultState(result)
        }
    }
    func makePARRequest(msisdn: String, clientId: String) {
        uiModel = UIModel.loading
        let activeCountry = AppStorageManager.getActiveCountry()
        tinggRequest.makePARRequesr(dataSource: activeCountry, msisdn: msisdn, clientId: clientId)
        baseRequest.makeRequest(tinggRequest: tinggRequest) { [unowned self] (result: Result<PARAndFSUDTO, ApiError>) in
            print("PAR result \(result)")
            handleResultState(result)
        }
    }
    func getCountryDictionary() {
        Task {
            countryDictionary = try await countryRepository.getCountriesAndDialCode()
        }
    }
    fileprivate func handleResultState<T: BaseDTOprotocol>(_ result: Result<T, ApiError>) {
        self.showLoader = false
        switch result {
        case .failure(let err):
            uiModel = UIModel.error(err.localizedDescription)
            print("Success \(err.localizedDescription)")
        case .success(let data):
            print("Success \(data)")
            let content = UIModel.Content(data: data, statusCode: data.statusCode, statusMessage: data.statusMessage)
            uiModel = UIModel.content(content)
        }
    }
    func observeUIModel(action: @escaping (BaseDTOprotocol) -> Void) {
        $uiModel.sink { uiModel in
            switch uiModel {
            case .content(let data):
                if data.statusMessage.lowercased().contains("succ") {
                    if let baseDto = data.data as? BaseDTOprotocol {
                        action(baseDto)
                    }
                }
            case .loading:
                print("loadingState")
            case .error:
                print("errorState")
            case .nothing:
                print("nothingState")
            }
        }.store(in: &subscriptions)
    }
    func save(data: DBObject) {
        dbTransaction.save(data: data)
    }
    func saveObjects(data: [DBObject]) {
        dbTransaction.saveObjects(data: data)
    }
    func printLn(methodName: String, message: String) {
        print("\(name) \(methodName) \(message)")
    }
}

class DBTransactions {
    private var realmManager: RealmManager = .init()
    init() {
        // Intentionally unimplemented...modular accessibility
    }
    func save(data: DBObject) {
        Task {
            await realmManager.save(data: data)
        }
    }
    func saveObjects(data: [DBObject]) {
        Task {
            await realmManager.save(data: data)
        }
    }
}
