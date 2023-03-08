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
public class HomeViewModel: ViewModel {
    @Published var defaultNetworkServiceId: String = AppStorageManager.getDefaultNetworkId()
    @Published public var nominationInfo = Observer<Enrollment>()
    @Published public var airTimeServices = sampleServices
    @Published public var servicesByCategory = [[Categorys]]()
    @Published public var services = Observer<MerchantService>()
    @Published public var rechargeAndBill = [MerchantService]()
    @Published public var profile = Profile()
    @Published public var transactionHistory = Observer<TransactionHistory>()
    @Published public var payers = Observer<MerchantPayer>()
    @Published public var dueBill = [Invoice]()
    @Published public var singleBillInvoice = Invoice()
    @Published public var serviceBill = Bill()
    @Published public var categoryNameAndServices = [String: [MerchantService]]()
    @Published var fetchBillUIModel = UIModel.nothing
    @Published var quickTopUIModel = UIModel.nothing
    @Published var categoryUIModel = UIModel.nothing
    @Published var rechargeAndBillUIModel = UIModel.nothing
    @Published var serviceBillUIModel = UIModel.nothing
    @Published var uiModel = UIModel.nothing
    @Published var defaultNetworkUIModel = UIModel.nothing
    @Published var buyAirtimeUiModel = UIModel.nothing
    @Published var navigateBillDetailsView = false
    @Published var navigateToBillForm = false
    @Published var gotoCategoriesAndServicesView = false
    @Published var showBillers = false
    @Published var buyAirtime = false
    @Published var selectedDefaultNetworkName = ""
    @Published var showNetworkList = false
    @Published public var showAlert = false
    @Published public var showCheckOutView = false
    @Published var permission = ContactManager()
    @Published var country = AppStorageManager.getCountry()
    @Published var sections: [TransactionSectionModel] = [.sample, .sample2]
    @Published var items:[TabLayoutItem] = [TabLayoutItem(title: "MY BILLS", view: AnyView(EmptyView()))]
    @Published public var subscriptions = Set<AnyCancellable>()
    @Published var profileImageUrl: String = ""

    public var homeUsecase: HomeUsecase
    public init(homeUsecase: HomeUsecase) {
        self.homeUsecase = homeUsecase
        getProfile()
        getQuickTopups()
        displayedRechargeAndBill()
//        fetchDueBills()
        getServicesByCategory()
        allRecharge()
    }
    
    public func getProfile() -> Profile? {
        if let profile = homeUsecase.getProfile() {
            self.profile = profile
            return profile
        }
        return nil
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
    
    public func getAirtimeServices() -> [MerchantService] {
        var services = [MerchantService]()
        do {
            services = try homeUsecase.getQuickTopups()
        } catch {
           print("Airtime service error")
        }
        return services
    }
    
    public func mapHistoryIntoChartData() -> [ChartData] {
        return homeUsecase.getBarChartMappedData().map { (key, value) in
            return ChartData(xName: ChartMonth.allCases[key-1], point: value)
        }.sorted { cd1, cd2 in
            ChartMonth.allCases.firstIndex(of: cd1.xName)! <  ChartMonth.allCases.firstIndex(of: cd2.xName)!
        }
    }
    public func mapHistoryIntoChartData(transactionHistory: [TransactionHistory]) -> [ChartData] {
        return mapTransactionHistoryIntoDictionary(transactionHistory: transactionHistory).map { (key, value) in
            return ChartData(xName: ChartMonth.allCases[key], point: value)
        }.sorted { cd1, cd2 in
            ChartMonth.allCases.firstIndex(of: cd1.xName)! <  ChartMonth.allCases.firstIndex(of: cd2.xName)!
        }
        
    }
    public func mapTransactionHistoryIntoDictionary(transactionHistory: [TransactionHistory]) -> [Int:Double] {
        var chartDataMap = [Int:Double]()
        let histories = transactionHistory
        histories.forEach { history in
            guard let validDateString = history.paymentDate.split(separator: ".").first else {
                fatalError("Invalid date format")
            }
            let date = makeDateFromString(validDateString: String(validDateString))
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            let monthIndex = components.month!
            let existingAmount = chartDataMap[monthIndex] ?? 0
           
            if let newAmount = Double( history.amount){
                let amount = existingAmount + newAmount
                chartDataMap[monthIndex] = amount
            }
        }
        return chartDataMap
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
                handleResultState(model: &fetchBillUIModel, (Result.success(dueBill) as Result<Any, Error>))
            } catch {
                handleResultState(model: &fetchBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    public func getDueBills()  {
        fetchBillUIModel = UIModel.loading
        Task {
            do {
                let billAccount = homeUsecase.getBillAccounts()
                let request = RequestMap.Builder()
                                .add(value: "FBA", for: .SERVICE)
                                .add(value: billAccount, for: .BILL_ACCOUNTS)
                                .build()
                dueBill = try await homeUsecase.fetchDueBills(request: request)
                handleResultState(model: &fetchBillUIModel, (Result.success(dueBill) as Result<Any, Error>))
            } catch {
                handleResultState(model: &fetchBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    public func getSingleDueBill(accountNumber: String, serviceId: String) {
        uiModel = UIModel.loading
        var tinggRequest: TinggRequest = .init()
        tinggRequest.service = "FB"
        tinggRequest.accountNumber = accountNumber
        tinggRequest.serviceId = serviceId
        Task {
         
            do {
                let singleBillInvoice = try await homeUsecase.getSingleDueBills(tinggRequest: tinggRequest)
                handleResultState(model: &uiModel, (Result.success(singleBillInvoice) as Result<Any, Error>))
            }catch {
                handleResultState(model: &uiModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    public func handleMCPRequests(action: MCPAction, profileInfoComputed: String, nom: Enrollment?=nil) {
        serviceBillUIModel = UIModel.loading
        var request = TinggRequest()
        request.service = "MCP"
        request.profileInfo = profileInfoComputed
        request.action = action.rawValue
        request.isNomination = "1"
        print("Request \(request)")
        Task {
            do {
                let response: Any
                switch action {
                case .ADD:
                    response = try await homeUsecase.handleMCPRequest(tinggRequest: request)
                case .UPDATE, .DELETE:
                    response = try await homeUsecase.handleMCPDeleteAndUpdateRequest(tinggRequest: request)
                }
                handleResultState(model: &serviceBillUIModel, (Result.success(response) as Result<Any, Error>))
            } catch {
                handleResultState(model: &serviceBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    
    func updateDefaultNetworkId(serviceName: String) {
        showAlert = true
        if !serviceName.isEmpty {
            let service = getAirtimeServices().first { serv in
                serv.serviceName == serviceName
            }
            var request = TinggRequest()
            if let s = service {
                request.defaultNetworkServiceId = s.hubServiceID
                request.service = "UPN"
                defaultNetworkUIModel = UIModel.loading
                Task {
                    do {
                        let result = try await homeUsecase.updateDefaultNetwork(request: request)
                        handleResultState(model: &defaultNetworkUIModel, (Result.success(result) as Result<Any, Error>))
                        defaultNetworkServiceId = service?.hubServiceID ?? ""
                        AppStorageManager.setDefaultNetwork(service: service!)
                    } catch {
                        handleResultState(model: &defaultNetworkUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
                    }
                }
            }
        } else {
            defaultNetworkUIModel = UIModel.error("You have not selected a network")
        }
    }
    func fetchPhoneContacts(action: @escaping (CNContact) -> Void) async {
        Task {
           await self.permission.fetchContacts { [unowned self] result in
                switch result {
                case .failure(let error):
                    showAlert = true
                    uiModel = UIModel.error(error.localizedDescription)
                case .success(let contacts):
                    action(contacts)
                }
            }
        }
        
    }
    func handleServiceAndNominationFilter(service: MerchantService, nomination: [Enrollment]) -> BillDetails? {
        if service.presentmentType != "None" {
            let nominations: [Enrollment] = nomination.filter { enrollment in
                return filterNominationInfoByHubServiceId(enrollment: enrollment, service: service)
            }
            let billDetails = BillDetails(service: service, info: nominations)
            return billDetails
        }
        return nil
    }
    func filterNominationInfoByHubServiceId(enrollment: Enrollment, service: MerchantService) -> Bool {
        String(enrollment.hubServiceID) == service.hubServiceID
    }

    /// Handle result
    nonisolated public func handleResultState<T, E>(model: inout Common.UIModel, _ result: Result<T, E>) where E : Error {
        switch result {
        case .failure(let apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case .success(let data):
            var content: UIModel.Content
            if data is BaseDTOprotocol {
                content = UIModel.Content(data: data, statusMessage: (data as! BaseDTO).statusMessage)
            } else {
                content = UIModel.Content(data: data)
            }
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


