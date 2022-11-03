//  HomeViewModel.swift
//  Created by Abdulrasaq on 24/07/2022.
import Common
import Core
import Combine
import Contacts
import Foundation
import Permissions
import SwiftUI

@MainActor
public class HomeViewModel: ObservableObject {
    @AppStorage(Utils.defaultNetworkServiceId) var defaultNetworkServiceId: String!
    @Published public var nominationInfo = Observer<Enrollment>()
    @Published public var airTimeServices = [MerchantService]()
    @Published public var servicesByCategory = [[Categorys]]()
    @Published public var services = Observer<MerchantService>()
    @Published public var rechargeAndBill = [MerchantService]()
    @Published public var profile = Profile()
    @Published public var transactionHistory = Observer<TransactionHistory>().objects
    @Published public var dueBill = [Invoice]()
    @Published public var singleBill = Invoice()
    @Published public var savedBill = SavedBill()
    @Published public var categoryNameAndServices = [String: [MerchantService]]()
    @Published var fetchBillUIModel = UIModel.nothing
    @Published var quickTopUIModel = UIModel.nothing
    @Published var categoryUIModel = UIModel.nothing
    @Published var rechargeAndBillUIModel = UIModel.nothing
    @Published var saveBillUIModel = UIModel.nothing
    @Published var uiModel = UIModel.nothing
    @Published var defaultNetworkUIModel = UIModel.nothing
    @Published var buyAirtimeUiModel = UIModel.nothing
    @Published var navigateBillDetailsView = false
    @Published var gotoAllRechargesView = false
    @Published var buyAirtime = false
    @Published var selectedDefaultNetworkName = ""
    @Published var showNetworkList = false
    @Published var showAlert = false
    @Published var permission = ContactManager()
    @Published public var subscriptions = Set<AnyCancellable>()

    public var homeUsecase: HomeUsecase
    public init(homeUsecase: HomeUsecase) {
        self.homeUsecase = homeUsecase
        getProfile()
        getQuickTopups()
        displayedRechargeAndBill()
        fetchDueBills()
        getServicesByCategory()
        allRecharge()
    }
    
    public func getProfile() {
        guard let profile = homeUsecase.getProfile() else {
            return
        }
        self.profile = profile
    }
    
    public func getServicesByCategory() {
        categoryUIModel = UIModel.loading
        Future<[[Categorys]], Never> { [unowned self] promise in
            let servicesByCategory = homeUsecase.categorisedCategories()
            promise(.success(servicesByCategory))
            categoryUIModel = UIModel.nothing
        }
        .assign(to: \.servicesByCategory, on: self)
        .store(in: &subscriptions)
    }
    public func getQuickTopups() {
        quickTopUIModel = UIModel.loading
        Future<[MerchantService], Never> { [unowned self] promise in
            do {
                let quicktopups = try homeUsecase.getQuickTopups()
                promise(.success(quicktopups))
                quickTopUIModel = UIModel.nothing
            } catch {
                quickTopUIModel = UIModel.error(error.localizedDescription)
            }
        }
        .assign(to: \.airTimeServices, on: self)
        .store(in: &subscriptions)
        return
    }
    
    public func mapHistoryIntoChartData() -> [ChartData] {
        return homeUsecase.getBarChartMappedData().map { (key, value) in
            print("Key \(key), value \(value)")
            return ChartData(xName: ChartMonth.allCases[key], point: value)
        }.sorted { cd1, cd2 in
            ChartMonth.allCases.firstIndex(of: cd1.xName)! <  ChartMonth.allCases.firstIndex(of: cd2.xName)!
        }
        
    }
    public func displayedRechargeAndBill() {
        rechargeAndBillUIModel =  UIModel.loading
        Future<[MerchantService], Never> { [unowned self] promise in
            do {
                let bill = try homeUsecase.displayedRechargeAndBill()
                promise(.success(bill))
                rechargeAndBillUIModel = UIModel.nothing
            } catch {
                rechargeAndBillUIModel = UIModel.error(error.localizedDescription)
            }
        }
        .assign(to: \.rechargeAndBill, on: self)
        .store(in: &subscriptions)
        return
    }
    
    public func allRecharge() {
        rechargeAndBillUIModel =  UIModel.loading
        Future<[String: [MerchantService]], Never> { [unowned self] promise in
            let recharges = homeUsecase.allRecharge()
            promise(.success(recharges))
            rechargeAndBillUIModel = UIModel.nothing
        }
        .assign(to: \.categoryNameAndServices, on: self)
        .store(in: &subscriptions)
        return
     
    }
    public func fetchDueBills()  {
        fetchBillUIModel = UIModel.loading
        Task {
            do {
                dueBill = try await homeUsecase.getDueBills()
                fetchBillUIModel = UIModel.nothing
            } catch {
                showAlert = true
                fetchBillUIModel = UIModel.error((error as? ApiError)?.localizedString ?? ApiError.serverErrorString)
            }
        }
    }
    public func getSingleDueBill(accountNumber: String, serviceId: String) {
        uiModel = UIModel.loading
        Task {
            do {
                singleBill = try await homeUsecase.getSingleDueBills(accountNumber: accountNumber, serviceId: serviceId)
                uiModel = UIModel.nothing
                navigateBillDetailsView.toggle()
            }catch {
                uiModel = UIModel.error((error as? ApiError)?.localizedString ?? ApiError.serverErrorString)
            }
        }
    }
    public func saveBill(tinggRequest: TinggRequest) {
        saveBillUIModel = UIModel.loading
        Task {
            do {
                savedBill = try await homeUsecase.saveBill(tinggRequest: tinggRequest, invoice: singleBill)
                let message = "Bill with reference \(savedBill.merchantAccountNumber) created"
                let content = UIModel.Content(statusMessage: message)
                saveBillUIModel = UIModel.content(content)
            } catch {
                saveBillUIModel = UIModel.error((error as? ApiError)?.localizedString ?? ApiError.serverErrorString)
            }
        }
    }
    func updateDefaultNetworkId(serviceName: String) {
        if !serviceName.isEmpty {
            let service = airTimeServices.first { serv in
                serv.serviceName == serviceName
            }
            var request = TinggRequest()
            request.defaultNetworkServiceId = service!.hubServiceID
            request.service = "UPN"
            defaultNetworkUIModel = UIModel.loading
           
            Task {
                do {
                    let result = try await homeUsecase.updateDefaultNetwork(request: request)
                    if result.statusCode == 200 {
                        showAlert = true
                        uiModel = UIModel.content(UIModel.Content(statusMessage: result.statusMessage))
                        defaultNetworkServiceId = service?.hubServiceID
                    }
                    showNetworkList = false
                } catch {
                    showAlert = true
                    defaultNetworkUIModel = UIModel.error((error as? ApiError)?.localizedString ?? ApiError.serverErrorString)
                }
            }
        } else {
            showAlert = true
            defaultNetworkUIModel = UIModel.error("You have not selected a network")
        }
    }
    func fetchPhoneContacts(action: @escaping (CNContact) -> Void) async {
        await permission.fetchContacts { [unowned self] result in
            switch result {
            case .failure(let error):
                showAlert = true
                uiModel = UIModel.error(error.localizedDescription)
            case .success(let contacts):
                action(contacts)
            }
        }
    }
    func observeUIModel(model: Published<UIModel>.Publisher, action: @escaping (BaseDTOprotocol) -> Void) {
        model.sink { [unowned self] uiModel in
            uiModelCases(uiModel: uiModel, action: action)
        }.store(in: &subscriptions)
    }
    func uiModelCases(uiModel: UIModel, action: @escaping (BaseDTOprotocol) -> Void) {
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
    }
}


