//
//  OnboardingViewModel.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import Combine
import Core
import Domain
import Foundation
import SwiftUI
class OnboardingViewModel: ObservableObject {
    @Published var showLoader = false
    @Published var showOTPView = false
    @Published var showError = false
    @Published var message = ""
    @Published var statusCode = 0
    @Published var results = Result<BaseDTOprotocol, ApiError>.failure(.networkError)
    var subscriptions = Set<AnyCancellable>()
    var tinggRequest: TinggRequest
    var fetchCountries: FetchCountries
    var baseRequest: BaseRequest
    init(tinggApiServices: TinggApiServices) {
        self.tinggRequest = .init()
        self.fetchCountries = .init(countryServices: tinggApiServices)
        self.baseRequest = .init(apiServices: tinggApiServices)
    }
    func makeActivationCodeRequest(msisdn: String, clientId: String) {
        resetViewmodelResult()
        showLoader.toggle()
        tinggRequest.getActivationCode(service: "MAK", msisdn: msisdn, clientId: clientId)
        baseRequest.makeRequest(tinggRequest: tinggRequest) { [unowned self] (result: Result<BaseDTO, ApiError>) in
            handleResultState(result)
            resetMessage()
        }
    }
    func confirmActivationCodeRequest(msisdn: String, clientId: String, code: String) {
        resetViewmodelResult()
        showLoader.toggle()
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
        resetViewmodelResult()
        showLoader.toggle()
        let activeCountry = Auth.getActiveCountry()
//        guard let country = active.country else { fatalError("Active country is nil")}
        tinggRequest.makePARRequesr(dataSource: activeCountry, msisdn: msisdn, clientId: clientId)
        baseRequest.makeRequest(tinggRequest: tinggRequest) { [unowned self] (result: Result<PARAndFSUDTO, ApiError>) in
            print("PAR result \(result)")
            handleResultState(result)
//            resetMessage()
        }
    }
    func allCountries() {
        fetchCountries.countriesCodesAndCountriesDialCodes()
    }
    func retainActiveCountry(country: String) {
        Auth.retainActiveCountry(country: country)
    }
    fileprivate func handleResultState<T: BaseDTOprotocol>(_ result: Result<T, ApiError>) {
        self.showLoader = false
        switch result {
        case .failure(let err):
            print("Success \(err.localizedDescription)")
            message = err.localizedDescription
            results = Result.failure(err)
        case .success(let data):
            print("Success \(data)")
            message = data.statusMessage
            results = Result.success(data)
        }
    }
    func resetMessage() {
        self.message = ""
    }
    fileprivate func resetViewmodelResult(){
        self.results = Result<BaseDTOprotocol, ApiError>.failure(.networkError)
    }
}
