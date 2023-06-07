//  HomeViewModel.swift
//  Created by Abdulrasaq on 24/07/2022.
import CoreUI
import Core
import Combine
import Contacts
import Foundation
import Permissions
import SwiftUI

@MainActor
public class HomeViewModel: ViewModel {
    @Published var defaultNetworkServiceId: Int? = AppStorageManager.getDefaultNetworkId()
    @Published public var nominationInfo = Observer<Enrollment>()
    @Published public var airTimeServices = sampleServices
    @Published public var servicesByCategory = [[CategoryEntity]]()
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
    @Published var campaignMessageUIModel = UIModel.nothing
    @Published var billReminderUIModel = UIModel.nothing
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
    @Published public var subscriptions = Set<AnyCancellable>()
    @Published var profileImageUrl: String = ""
    @Published var listOfPaymentOptions = [
        PaymentOptionItem(optionName: "Mpesa", isSelected: false),
        PaymentOptionItem(optionName: "Viusasa", isSelected: false)
    ]

    public var homeUsecase: HomeUsecase
    public init(homeUsecase: HomeUsecase) {
        self.homeUsecase = homeUsecase
        getProfile()
//        displayedRechargeAndBill()

//        getServicesByCategory()
//        allRecharge()
    }
    
    public func updateProfile(_ requestString: String) {
        let request = RequestMap.Builder()
                        .add(value: "", for: .PROFILE_INFO)
                        .add(value: "UPDATE", for: .ACTION)
                        .add(value: "2", for: .IS_NOMINATION)
                        .add(value: "Y", for: .IS_EXPLICIT)
                        .add(value: "", for: "WISHLIST")
                        .add(value: requestString, for: "MULA_PROFILE")
                        .add(value: "MCP", for: .SERVICE)
                        .build()
        Task {
            do {
                let result = try await homeUsecase.updateProfile(request: request)
                handleResultState(model: &uiModel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &uiModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    
    public func getProfile() -> Profile? {
        if let profile = homeUsecase.getProfile() {
//            self.profile = profile
            return profile
        }
        return nil
    }
    func updateDefaultNetworkId(request: RequestMap) {
        defaultNetworkUIModel = UIModel.loading
        
        Task {
            do {
                let result = try await homeUsecase.updateDefaultNetwork(request: request)
                handleResultState(model: &defaultNetworkUIModel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &defaultNetworkUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }

    }
    
    func updateBillReminder(request: RequestMap) {
        billReminderUIModel = UIModel.loading
        Task {
            do {
                let result = try await homeUsecase.updateDefaultNetwork(request: request)
                handleResultState(model: &billReminderUIModel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &billReminderUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }

    }
    
    func updateCampaignMessages(request: RequestMap) {
        campaignMessageUIModel = UIModel.loading
        Task {
            do {
                let result = try await homeUsecase.updateDefaultNetwork(request: request)
                handleResultState(model: &campaignMessageUIModel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &campaignMessageUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }

    }
    
    public func getServicesByCategory() {
        categoryUIModel = UIModel.loading
        let servicesByCategory = homeUsecase.categorisedCategories()
        handleResultState(model: &categoryUIModel, (Result.success(servicesByCategory) as Result<Any, Error>))
    }
    public func getQuickTopups() {
        quickTopUIModel = UIModel.loading
        do {
            let quicktopups = try homeUsecase.getQuickTopups()
            handleResultState(model: &quickTopUIModel, (Result.success(quicktopups) as Result<Any, Error>))
        } catch {
            handleResultState(model: &quickTopUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
        }
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
        do {
            let bill = try homeUsecase.displayedRechargeAndBill()
            Log.d(message: "Recharge \(bill)")
            handleResultState(model: &rechargeAndBillUIModel, (Result.success(bill) as Result<Any, Error>))
        } catch {
            handleResultState(model: &rechargeAndBillUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
        }
        return
    }
    
    public func allRecharge() {
        rechargeAndBillUIModel =  UIModel.loading
        let recharges = homeUsecase.allRecharge()
        handleResultState(model: &rechargeAndBillUIModel, (Result.success(recharges) as Result<Any, Error>))
        return
     
    }
    public func fetchDueBills()  {
        fetchBillUIModel = UIModel.loading
//        Task {
//            do {
//                dueBill = try await homeUsecase.getDueBills()
//                handleResultState(model: &fetchBillUIModel, (Result.success(dueBill) as Result<Any, Error>))
//            } catch {
//                handleResultState(model: &fetchBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
//            }
//        }
    }
    public func getDueBills()  {
        fetchBillUIModel = UIModel.loading
        let billAccount = homeUsecase.getBillAccounts()
        var baa:[[String: String]] = []
       let baaaa = billAccount.reduce(into: [:]) { partialResult, ba in
            partialResult["SERVICE_ID"] = ba.serviceId
            partialResult["ACCOUNT_NUMBER"] = ba.accountNumber
        }
        Log.d(message: "\(baaaa)")
        billAccount.forEach { ba in
            var d = [String: String]()
            d["SERVICE_ID"] = ba.serviceId
            d["ACCOUNT_NUMBER"] = ba.accountNumber
            baa.append(d)
        }
    
        let request = RequestMap.Builder()
                        .add(value: "FBA", for: .SERVICE)
                        .add(value: baa, for: .BILL_ACCOUNTS)
                        .add(value: 1, for: "IS_MULTIPLE")
                        .build()
         Task {
             do {
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
    public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>, showAlertOnSuccess: Bool = false) where E : Error {
        switch result {
        case .failure(let apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case .success(let data):
            var content: UIModel.Content
            if let d = data as? BaseDTOprotocol {
                content = UIModel.Content(data: data, statusMessage: d.statusMessage, showAlert: showAlertOnSuccess)
            } else {
                content = UIModel.Content(data: data, showAlert: showAlertOnSuccess)
            }
            model = UIModel.content(content)
            return
        }
    }

}


