//
//  OnboardingViewModel.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import ApiModule
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
    var getActivationCode: GetActivationCode
    var confirmActivationCode: ConfirmActivationCode
    init() {
        self.tinggRequest = .init()
        self.getActivationCode = .init()
        self.confirmActivationCode = .init()
    }
    func makeActivationCodeRequest(msisdn: String, clientId: String) {
        showLoader.toggle()
        tinggRequest.getActivationCode(service: "MAK", msisdn: msisdn, clientId: clientId)
        getActivationCode.getCode(activationCodeRequest: tinggRequest) { [unowned self] result in
            handleResultState(result)
            self.showOTPView = true
            resetMessage()
        }
    }
    func confirmActivationCodeRequest(msisdn: String, clientId: String, code: String) {
        showLoader.toggle()
        tinggRequest.confirmActivationCode(service: "VAK",
                                      msisdn: msisdn,
                                      clientId: clientId, code: code)
        confirmActivationCode.confirmCode(activationCodeRequest: tinggRequest) { [unowned self] result in
            handleResultState(result)
            print("Confirmation result \(result)")
        }
    }
    fileprivate func handleResultState(_ result: Result<BaseDTO, ApiError>) {
        self.showLoader = false
        switch result {
        case .failure(let err):
            message = err.localizedDescription
        case .success(let data):
            message = data.statusMessage
        }
    }
    func resetMessage() {
        self.message = ""
    }
}
