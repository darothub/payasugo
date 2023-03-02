//  OnboardingViewModel.swift
//  TinggIOS
//  Created by Abdulrasaq on 13/07/2022.
import Combine
import Common
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
   
    var onboardingUseCase: OnboardingUseCase
    var name = "OnboardingViewModel"
    
    public init(onboardingUseCase: OnboardingUseCase) {
        self.onboardingUseCase = onboardingUseCase
        getCountryDictionary()
    }
    /// Request for activation code
//    func makeActivationCodeRequest() {
//        onActivationRequestUIModel = UIModel.loading
//        Task {
//            var tinggRequest: TinggRequest = .init()
//            tinggRequest.service = "MAK"
//            let result = try await onboardingUseCase.makeActivationCodeRequest(tinggRequest: tinggRequest)
//            handleResultState(model: &onActivationRequestUIModel, result)
//        }
//    }
    func makeActivationCodeRequest() {
        onActivationRequestUIModel = UIModel.loading
        Task {
            var tinggRequest: RequestMap = RequestMap.Builder()
                .add(value: "MAK", for: .SERVICE)
                .build()
//            tinggRequest.service = "MAK"
            let result = try await onboardingUseCase.makeActivationCodeRequest(tinggRequest: tinggRequest)
            handleResultState(model: &onActivationRequestUIModel, result)
        }
    }
    /// Confirm activation code
    func confirmActivationCodeRequest(code: String) {
        onConfirmActivationUIModel = UIModel.loading
        Task {
            let tinggRequest: RequestMap =  RequestMap.Builder()
                .add(value: "VAK", for: .SERVICE)
                .add(value: code, for: .ACTIVATION_CODE)
                .build()
//            tinggRequest.service = "VAK"
//            tinggRequest.activationCode = code
//            print("requestVAK \(tinggRequest)")
            let result = try await onboardingUseCase.confirmActivationCodeRequest(tinggRequest: tinggRequest, code: code)
        
            handleResultState(model: &onConfirmActivationUIModel, result)
        }
    }
    /// Request for PARandFSU
    func makePARRequest() {
        onParRequestUIModel = UIModel.loading
        Task {
            let tinggRequest: RequestMap =  RequestMap.Builder()
                .add(value: "PAR", for: .SERVICE)
                .build()
//            tinggRequest.service = "PAR"
//            print("requestPAR \(tinggRequest)")
            let result = try await onboardingUseCase.makePARRequest(tinggRequest: tinggRequest)
//            print("Result2 \(result)")
            handleResultState(model: &onParRequestUIModel, result)
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
    /// Handle result
    nonisolated public func handleResultState<T, E>(model: inout Common.UIModel, _ result: Result<T, E>) where E : Error {
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




