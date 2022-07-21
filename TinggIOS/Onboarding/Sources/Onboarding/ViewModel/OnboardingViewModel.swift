//
//  OnboardingViewModel.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//

import Core
import Domain
import Foundation
import SwiftUI
class OnboardingViewModel: ObservableObject {
    @Published var showLoader = false
    @Published var showOTPView = false
    @Published var showError = false
    @Published var message = ""
    var tinggRequest: TinggRequest
    var fetchCountries: FetchCountries
    var baseRequest: BaseRequest
    init(tinggApiServices: TinggApiServices) {
        self.tinggRequest = .init()
        self.fetchCountries = .init(countryServices: tinggApiServices)
        self.baseRequest = .init(countryServices: tinggApiServices)
    }
    func makeActivationCodeRequest(msisdn: String, clientId: String) {
        showLoader.toggle()
        tinggRequest.getActivationCode(service: "MAK", msisdn: msisdn, clientId: clientId)
        baseRequest.makeRequest(tinggRequest: tinggRequest) { [unowned self] (result: Result<BaseDTO, ApiError>) in
            handleResultState(result)
            self.showOTPView = true
            resetMessage()
        }
    }
    func confirmActivationCodeRequest(msisdn: String, clientId: String, code: String) {
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
        showLoader.toggle()
        tinggRequest.getActivationCode(service: "MAK", msisdn: msisdn, clientId: clientId)
        baseRequest.makeRequest(tinggRequest: tinggRequest) { [unowned self] (result: Result<BaseDTO, ApiError>) in
            handleResultState(result)
            self.showOTPView = true
            resetMessage()
        }
    }
    func allCountries() {
        fetchCountries.countriesCodesAndCountriesDialCodes()
    }
    fileprivate func handleResultState(_ result: Result<BaseDTO, ApiError>) {
        self.showLoader = false
        switch result {
        case .failure(let err):
            message = err.localizedDescription
        case .success(let data):
            print("Success \(data)")
            message = data.statusMessage
        }
    }
    func resetMessage() {
        self.message = ""
    }
}
