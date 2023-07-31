//
//  BillViewModel.swift
//  
//
//  Created by Abdulrasaq on 04/07/2023.
//
import CoreUI
import Core
import Foundation
@MainActor
class BillViewModel : ViewModel {
    @Published var singleBillUIModel = UIModel.nothing
    @Published var serviceBillUIModel = UIModel.nothing
    @Published var fetchBillUIModel = UIModel.nothing
    @Published var savedBillUIModel = UIModel.nothing
    @Published var rechargeAndBillUIModel =  UIModel.loading
    @Published public var showBundles = false
    @Published public var bundleModel = BundleModel()
    private var getSingleBillUsecase: GetSingleBillUsecase
    private var mcpUsecase: MCPUsecase
    private var getDueBillUsecase: GetDueBillUsecase
    private var getCategoriesAndServicesUsecase: CategoriesAndServicesUsecase
    private var getBarChartDataUsecase: BarChartUsecase
    
    init(
        getSingleBillUsecase: GetSingleBillUsecase,
        mcpUsecase: MCPUsecase,
        getDueBillUsecase: GetDueBillUsecase,
        getCategoriesAndServicesUsecase: CategoriesAndServicesUsecase,
        getBarChartDataUsecase: BarChartUsecase
    ) {
        self.getSingleBillUsecase = getSingleBillUsecase
        self.mcpUsecase = mcpUsecase
        self.getDueBillUsecase = getDueBillUsecase
        self.getCategoriesAndServicesUsecase = getCategoriesAndServicesUsecase
        self.getBarChartDataUsecase = getBarChartDataUsecase
    }
    
    public func allRecharge() -> [String: [MerchantService]] {
        rechargeAndBillUIModel =  UIModel.loading
        let recharges = getCategoriesAndServicesUsecase()
        handleResultState(model: &rechargeAndBillUIModel, (Result.success(recharges) as Result<Any, Error>))
        return recharges

    }
    public func getRechargeAndOtherBillServices() {
        rechargeAndBillUIModel =  UIModel.loading
        let result = getCategoriesAndServicesUsecase.displayedRechargeAndBill()
        handleResultState(model: &rechargeAndBillUIModel, (Result.success(result) as Result<Any, Error>))
    }
    public func getTitleAndServicesList() -> [TitleAndListItem] {
        let categoryNameAndServices = allRecharge()
        let titleAndListItem = categoryNameAndServices.keys
                 .sorted(by: <)
                 .map{TitleAndListItem(title: $0, services: categoryNameAndServices[$0, default: []])}
        return titleAndListItem
    }
    public func getSingleDueBill(request: RequestMap) {
        singleBillUIModel = UIModel.loading
        Task {
            do {
                let singleBillInvoice = try await getSingleBillUsecase(request: request)
                handleResultState(model: &singleBillUIModel, (Result.success(singleBillInvoice) as Result<Any, Error>))

            } catch {
                handleResultState(model: &singleBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    public func getBarChartData() -> [ChartData] {
        return getBarChartDataUsecase().map { (key, value) in
            return ChartData(xName: ChartMonth.allCases[key-1], point: value)
        }.sorted { cd1, cd2 in
            ChartMonth.allCases.firstIndex(of: cd1.xName)! <  ChartMonth.allCases.firstIndex(of: cd2.xName)!
        }

    }
    public func getSavedBills() {
        savedBillUIModel = UIModel.loading
        let result = getDueBillUsecase.getSavedBill()
        handleResultState(model: &savedBillUIModel, (Result.success(result) as Result<Any, Error>))
    }
    public func getDueBills() async {
        fetchBillUIModel = UIModel.loading
        let billAccounts = getDueBillUsecase.getBillAccounts()
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
            let dueBill  = try await getDueBillUsecase.getDueBills(request: request) as FetchBillDTO
            handleResultState(model: &fetchBillUIModel, (Result.success(dueBill.fetchedBills) as Result<Any, Error>))
        } catch {
            handleResultState(model: &fetchBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
        }
    
    }
    public func handleMCPRequests(action: MCPAction, profileInfoComputed: String, nom: Enrollment?=nil) async {
        serviceBillUIModel = UIModel.loading
        let request = RequestMap.Builder()
            .add(value: "MCP", for: .SERVICE)
            .add(value: profileInfoComputed, for: .PROFILE_INFO)
            .add(value: action.rawValue, for: .ACTION)
            .add(value: "1§", for: .IS_NOMINATION)
            .build()
        var response: BaseDTOprotocol
        do {
            switch action {
            case .ADD:
                response = try await mcpUsecase(request: request) as Bill
            case .UPDATE, .DELETE:
                response = try await mcpUsecase(request: request) as BaseDTO
            }
            handleResultState(model: &serviceBillUIModel, (Result.success(response) as Result<Any, Error>))
        } catch {
            handleResultState(model: &serviceBillUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
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
