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
    @Published var uiModel = UIModel.nothing
    private var subscriptions = Set<AnyCancellable>()
    private var dbTransaction = DBTransactions()
    @Published public var countryDictionary = [String: String]()
    @Published public var countriesDb = Observer<Country>().objects
    var onboardingUseCase: OnboardingUseCase
    var name = "OnboardingViewModel"
    
    public init(onboardingUseCase: OnboardingUseCase) {
        self.onboardingUseCase = onboardingUseCase
        getCountryDictionary()
    }
    func makeActivationCodeRequest() {
        uiModel = UIModel.loading
        Task {
            var tinggRequest: TinggRequest = .init()
            tinggRequest.service = "MAK"
            print("requestMAK \(tinggRequest)")
            let result = try await onboardingUseCase.makeActivationCodeRequest(tinggRequest: tinggRequest)
            handleResultState(result as Result<BaseDTO, ApiError>)
        }
    }
    func confirmActivationCodeRequest(code: String) {
        uiModel = UIModel.loading
        Task {
            var tinggRequest: TinggRequest = .init()
            tinggRequest.service = "VAK"
            tinggRequest.activationCode = code
            print("requestVAK \(tinggRequest)")
            let result = try await onboardingUseCase.confirmActivationCodeRequest(tinggRequest: tinggRequest, code: code)
            handleResultState(result as Result<BaseDTO, ApiError>)
        }
    }
    func makePARRequest() {
        uiModel = UIModel.loading
        Task {
            var tinggRequest: TinggRequest = .init()
            tinggRequest.service = "PAR"
            print("requestPAR \(tinggRequest)")
            let result = try await onboardingUseCase.makePARRequest(tinggRequest: tinggRequest )
            print("Result2 \(result)")
            handleResultState(result as Result<PARAndFSUDTO, ApiError>)
        }
    }
    func getCountryDictionary() {
        Task {
            countryDictionary = try await onboardingUseCase.getCountryDictionary()
        }
    }
    
    func getCountryByDialCode(dialCode: String) -> Country? {
        return onboardingUseCase.getCountryByDialCode(dialCode: dialCode)
    }
    fileprivate func handleResultState<T: BaseDTOprotocol>(_ result: Result<T, ApiError>) {
        DispatchQueue.main.async { [unowned self] in
            self.showLoader = false
            switch result {
            case .failure(let apiError):
                uiModel = UIModel.error(apiError.localizedString)
                print("Failure \(apiError.localizedString)")
                return
            case .success(let data):
                print("Success \(data)")
                let content = UIModel.Content(data: data, statusCode: data.statusCode, statusMessage: data.statusMessage)
                uiModel = UIModel.content(content)
                return
            }
        }
    }
    func observeUIModel(action: @escaping (BaseDTOprotocol) -> Void) {
        $uiModel.sink { uiModel in
            switch uiModel {
            case .content(let data):
                if data.statusMessage.lowercased().contains("succ"),
                   let baseDto = data.data as? BaseDTOprotocol {
                    action(baseDto)
                }
                return
            case .loading:
                print("loadingState")
            case .error:
                print("errorState")
                return
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
    func stopUIModelSubscription() {
        subscriptions.removeAll()
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


