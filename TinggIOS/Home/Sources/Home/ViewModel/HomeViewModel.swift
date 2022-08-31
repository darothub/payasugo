//  HomeViewModel.swift
//  Created by Abdulrasaq on 24/07/2022.
import Common
import Core
import Combine
import Foundation

@MainActor
public class HomeViewModel: ObservableObject {
    @Published public var categories = Observer<Categorys>().objects
    @Published public var nominationInfo = Observer<Enrollment>().objects
    @Published public var airTimeServices = [MerchantService]()
    @Published public var processedCategories = [[Categorys]]()
    @Published public var rechargeAndBill = [MerchantService]()
    @Published public var profile = Profile()
    @Published public var transactionHistory = Observer<TransactionHistory>().objects
    @Published public var dueBill = [FetchedBill]()
    @Published var fetchBillUIModel = UIModel.nothing
    @Published public var subscriptions = Set<AnyCancellable>()
    public var homeUsecase: HomeUsecase

    public init(homeUsecase: HomeUsecase) {
        self.homeUsecase = homeUsecase
        processedCategories = categories.reversed().reversed().chunked(into: 4)
        getProfile()
        getQuickTopups()
        displayedRechargeAndBill()
        fetchDueBills()
    }
    

    public func getProfile() {
        guard let profile = homeUsecase.getProfile() else {
            return
        }
        self.profile = profile
    }
    public func getQuickTopups() {
        Future<[MerchantService], Never> { [unowned self] promise in
            let airtimes = categories.filter {$0.categoryName == "Airtime"}
            let theAirtimeCategory = airtimes[0]
            promise(.success(services.filter { $0.categoryID == theAirtimeCategory.categoryID}))
        }
        .assign(to: \.airTimeServices, on: self)
        .store(in: &subscriptions)
        return
    }
    public func mapHistoryIntoChartData() -> [ChartData] {
        var chartDataMap = [Int:Double]()
        transactionHistory.forEach { history in
            guard let validDateString = history.paymentDate?.split(separator: ".").first else {
                fatalError("Invalid date format")
            }
            let date = makeDateFromString(validDateString: String(validDateString))
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            let monthIndex = components.month!
            let existingAmount = chartDataMap[monthIndex] ?? 0
            let newAmount = existingAmount + (Double(history.amount!) ?? 0)
            chartDataMap[monthIndex] = newAmount
        }
        return chartDataMap.map { (key, value) in
            ChartData(xName: ChartMonth.allCases[key], point: value)
        }.sorted { cd1, cd2 in
            ChartMonth.allCases.firstIndex(of: cd1.xName)! <  ChartMonth.allCases.firstIndex(of: cd2.xName)!
        }
        
    }
    public func displayedRechargeAndBill() {
        Future<[MerchantService], Never> { [unowned self] promise in
            promise(.success(homeUsecase.displayedRechargeAndBill()))
        }
        .assign(to: \.rechargeAndBill, on: self)
        .store(in: &subscriptions)
        return
    }
    
    public func fetchDueBills()  {
        fetchBillUIModel = UIModel.loading
        let enrollments =  services.flatMap { service in
            self.nominationInfo.filter {enrollment  in
                (String(enrollment.hubServiceID) == service.hubServiceID)  && service.presentmentType == "hasPresentment"
            }
        }
        let billAccounts = enrollments.map { nominationInfo in
            BillAccount(serviceId:String( nominationInfo.hubServiceID), accountNumber: String(nominationInfo.accountNumber!))
        }
        var tinggRequest: TinggRequest = .shared
        tinggRequest.service = "FBA"
        tinggRequest.billAccounts = billAccounts.reversed()
        print("HomeVm: Request \(tinggRequest)")
        Task {
            do {
                dueBill = try await homeUsecase.fetchDueBill(tinggRequest: tinggRequest)
                dueBill = dueBill.filter { bill in
                    let daysDiff = abs((makeDateFromString(validDateString: bill.dueDate) - Date()).day)
                    return daysDiff <= 5
                }
                fetchBillUIModel = UIModel.nothing
            } catch {
                fetchBillUIModel = UIModel.error((error as? ApiError)?.localizedString ?? "Server error, please try again")
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


