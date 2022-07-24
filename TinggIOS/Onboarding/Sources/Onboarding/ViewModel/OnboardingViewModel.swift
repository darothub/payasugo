//
//  OnboardingViewModel.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import Combine
import Common
import Core
import Domain
import Foundation
import RealmSwift
import SwiftUI
class OnboardingViewModel: ObservableObject {
    @Published var showLoader = false
    @Published var showOTPView = false
    @Published var showError = false
    @Published var message = ""
    @Published var statusCode = 0
    @Published var results = Result<BaseDTOprotocol, ApiError>.failure(.networkError)
    @Published var uiModel = UIModel.nothing
    private var subscriptions = Set<AnyCancellable>()
    private var dbTransaction = DBTransactions()
    @ObservedResults(Country.self) public var countriesDb
    var tinggRequest: TinggRequest
    var fetchCountries: FetchCountries
    var baseRequest: BaseRequest
    init(tinggApiServices: TinggApiServices) {
        self.tinggRequest = .init()
        self.fetchCountries = .init(countryServices: tinggApiServices)
        self.baseRequest = .init(apiServices: tinggApiServices)
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
        let activeCountry = Auth.getActiveCountry()
        tinggRequest.makePARRequesr(dataSource: activeCountry, msisdn: msisdn, clientId: clientId)
        baseRequest.makeRequest(tinggRequest: tinggRequest) { [unowned self] (result: Result<PARAndFSUDTO, ApiError>) in
            print("PAR result \(result)")
            handleResultState(result)
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
            uiModel = UIModel.error(err.localizedDescription)
            print("Success \(err.localizedDescription)")
        case .success(let data):
            print("Success \(data)")
            uiModel = UIModel.content(data)
        }
    }
    func observeUIModel(action: @escaping (BaseDTOprotocol) -> Void) {
        $uiModel.sink { uiModel in
            switch uiModel {
            case .content(let data):
               action(data)
            case .loading:
                print("loadingState")
            case .error(_):
                print("errorState")
            case .nothing:
                print("nothingState")
            }
        }.store(in: &subscriptions)
    }
    func save<O: Object>(data: O){
        dbTransaction.save(data: data)
    }
    func saveObjects<O: Object>(data: [O]) {
        dbTransaction.saveObjects(data: data)
    }
}


class DBTransactions {
    @ObservedResults(Profile.self) var profiles
    @ObservedResults(Categorys.self) var categorys
    @ObservedResults(MerchantService.self) var merchantServices
    @ObservedResults(MerchantPayer.self) var merchantPayers
    @ObservedResults(Enrollment.self) var enrollments
    @ObservedResults(Contact.self) var contacts
    @ObservedResults(TransactionHistory.self) var transactions
    @ObservedResults(SMSTemplate.self) var smsTemplates
//    @ObservedResults(BundleDatum.self) var bundleData
    @ObservedResults(SecurityQuestion.self) var securityQuestions
    @ObservedResults(Card.self) var cards
    @ObservedResults(Highlight.self) var highlights
//    @ObservedResults(VirtualCard.self) var virtualCards
//    @ObservedResults(MulaProfileInfo.self) var mulaProfileInfo
    @ObservedResults(ManualBill.self) var manualBills
    private var realmManager: RealmManager = .init()
    init() {}
    func saveCategories(category: Categorys) {
        $categorys.append(category)
    }
    func save<O: Object>(data: O){
        realmManager.save(data: data)
    }
    func saveObjects<O: Object>(data: [O]) {
        realmManager.save(data: data)
    }
}
