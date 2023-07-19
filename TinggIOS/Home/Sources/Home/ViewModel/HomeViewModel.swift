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
    @Published public var dueBill = [DynamicInvoiceType]()
    @Published public var singleBillInvoice = Invoice()
    @Published public var serviceBill = Bill()
    @Published public var categoryNameAndServices = [String: [MerchantService]]()
    @Published public var fetchBillUIModel = UIModel.nothing
    @Published public var quickTopUIModel = UIModel.nothing
    @Published public var categoryUIModel = UIModel.nothing
    @Published public var rechargeAndBillUIModel = UIModel.nothing
    @Published var serviceBillUIModel = UIModel.nothing
    @Published var singleBillUIModel = UIModel.nothing
    @Published var savedBillUIModel = UIModel.nothing
    @Published public var uiModel = UIModel.nothing
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
    @Published public var showBundles = false
    @Published public var bundleModel = BundleModel()
    var realmManager: RealmManager = .init()
    @Published var listOfPaymentOptions = [
        PaymentOptionItem(optionName: "Mpesa", isSelected: false),
        PaymentOptionItem(optionName: "Viusasa", isSelected: false)
    ]

    public var homeUsecase: HomeUsecase
    public init(homeUsecase: HomeUsecase) {
        self.homeUsecase = homeUsecase
    }
    
    func fetchSystemUpdate() async  {
        let systemUpdateRequest: RequestMap =  RequestMap.Builder()
            .add(value: "PAR", for: .SERVICE)
            .build()
        uiModel = UIModel.loading
        do {
            let response = try await homeUsecase.fetchSystemUpdate(request: systemUpdateRequest)
            await saveDataIntoDB(data: try response.get())
            handleResultState(model: &uiModel, response)
        } catch {
            handleResultState(model: &uiModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
        }
    }
    /// Save System  update response in database
    func saveDataIntoDB(data: SystemUpdateDTO) async  {
        
        let sortedCategories = data.categories.sorted { category1, category2 in
            category1.categoryID.convertStringToInt() < category2.categoryID.convertStringToInt()
        }.filter { category in
            category.isActive
        }.map { c in
            c.toEntity
        }
        realmManager.save(data: sortedCategories)
        realmManager.save(data: data.contactInfo.map {$0.toEntity})
        let services = data.services.filter { service in
            service.isActive
        }
        if let defaultNetworkServiceId = data.defaultNetworkServiceID {
            AppStorageManager.setDefaultNetworkId(id: defaultNetworkServiceId)
            let defaultNetwork = services.first { s in
                Log.d(message: "default \(defaultNetworkServiceId) \(s.hubServiceID.toInt)")
                return s.hubServiceID.toInt == defaultNetworkServiceId
            }
           
            if let service = defaultNetwork {
                AppStorageManager.setDefaultNetwork(service: service.toEntity)
            }
        }
        
        realmManager.save(data: services.map {$0.toEntity})
        realmManager.save(data: data.transactionSummaryInfo.map {$0.toEntity})
        let eligibleNomination = data.nominationInfo.filter { nom in
            nom.clientProfileAccountID?.toInt != nil
        }
        let validNomination = eligibleNomination.filter { e in
            return !e.isReminder.toBool && e.isActive
        }
        let validEnrollment = validNomination.map {$0.toEntity}
        realmManager.save(data: validEnrollment)
        let profile = data.mulaProfileInfo.mulaProfile[0]
        realmManager.save(data: profile.toEntity)
        realmManager.save(data: data.virtualCards.map {$0.toEntity})
        let payers: [MerchantPayer] = data.merchantPayers.map {$0.toEntity}
        realmManager.save(data: data.securityQuestions.map {$0.toEntity})
        realmManager.save(data: payers)

        realmManager.save(data: data.bundleData.map {$0.toEntity})
      
        AppStorageManager.retainCountriesExtraInfo(countrExtra: data.countriesExtraInfo)
    }
 
    public func getAllServicesForAddBill() -> [TitleAndListItem] {
        let allRecharges = allRecharge()
       return allRecharges.keys
            .sorted(by: <)
            .map{TitleAndListItem(title: $0, services: allRecharges[$0] ?? [])}
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
    
    public func getServicesByCategory() -> [[CategoryDTO]] {
        categoryUIModel = UIModel.loading
        let servicesByCategory = homeUsecase.categorisedCategories()
        handleResultState(model: &categoryUIModel, (Result.success(servicesByCategory) as Result<Any, Error>))
        return servicesByCategory
    }
    public func getQuickTopups() -> [MerchantService] {
        quickTopUIModel = UIModel.loading
        let quicktopups = homeUsecase.getQuickTopups()
        handleResultState(model: &quickTopUIModel, (Result.success(quicktopups) as Result<Any, Error>))
        return quicktopups
    }
    public func getDueBills() async {
        fetchBillUIModel = UIModel.loading
        let billAccounts = getBillAccount()
        var billAccountDict:[[String: String]] = []
        billAccounts.forEach { billAccount in
            var d = [String: String]()
            d["SERVICE_ID"] = billAccount.serviceId
            d["ACCOUNT_NUMBER"] = billAccount.accountNumber
            billAccountDict.append(d)
        }
        let request = RequestMap.Builder()
                        .add(value: "FBA", for: .SERVICE)
                        .add(value: billAccountDict, for: .BILL_ACCOUNTS)
                        .add(value: 1, for: "IS_MULTIPLE")
                        .build()
        do {
            dueBill = try await homeUsecase.fetchDueBills(request: request)
            
            handleResultState(model: &fetchBillUIModel, (Result.success(dueBill) as Result<Any, Error>))
        } catch {
            handleResultState(model: &fetchBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
        }
    
    }
    
    
    public func getBillAccount() -> [BillAccount] {
        homeUsecase.getBillAccounts()
    }
//    public func getSavedBill() {
//        savedBillUIModel = UIModel.loading
//        let invoices = Observer<Invoice>().getEntities()
//        let services = Observer<MerchantService>().getEntities()
//        let billAccounts = getBillAccount()
//        let filteredServicesAndEnrollment = billAccounts.compactMap { ba in
//            let invoice = invoices.first { i in
//                i.billReference == ba.accountNumber
//            }
//            let service = services.first { s in
//                ba.serviceId == s.hubServiceID
//            }
//            return (s: service, i: invoice)
//        }
//
//        let savedBillItems = filteredServicesAndEnrollment.compactMap { (s, i) in
//            if let service = s, let bill = i {
//                return DueBillItem(
//                    serviceName: service.serviceName,
//                    serviceImageString: service.serviceLogo,
//                    beneficiaryName: bill.customerName,
//                    accountNumber: bill.billReference,
//                    amount: "",
//                    dueDate: ""
//                )
//                 
//            } else {
//                return nil
//            }
//        }
//        handleResultState(model: &savedBillUIModel, (Result.success(savedBillItems) as Result<Any, Error>))
//    }
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
    public func displayedRechargeAndBill() -> [MerchantService]{
        rechargeAndBillUIModel =  UIModel.loading
        let data = homeUsecase.displayedRechargeAndBill()
        handleResultState(model: &rechargeAndBillUIModel, (Result.success(data) as Result<Any, Error>))
        return data
    }
    
    public func allRecharge() -> [String: [MerchantService]] {
        rechargeAndBillUIModel =  UIModel.loading
        let recharges = homeUsecase.allRecharge()
        handleResultState(model: &rechargeAndBillUIModel, (Result.success(recharges) as Result<Any, Error>))
        return recharges
     
    }

    public func getSingleDueBill(request: RequestMap) {
        singleBillUIModel = UIModel.loading
        
        Task {
            do {
                let singleBillInvoice = try await homeUsecase.getSingleDueBills(tinggRequest: request)
                handleResultState(model: &singleBillUIModel, (Result.success(singleBillInvoice) as Result<Any, Error>))

            }catch {
                handleResultState(model: &singleBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    public func handleMCPRequests(action: MCPAction, profileInfoComputed: String, nom: Enrollment?=nil) async {
        serviceBillUIModel = UIModel.loading
        var request = TinggRequest()
        request.service = "MCP"
        request.profileInfo = profileInfoComputed
        request.action = action.rawValue
        request.isNomination = "1"
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


