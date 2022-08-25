//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/07/2022.
//
import Common
import Core
import Combine
import Foundation

public class HomeViewModel: ObservableObject {
    @Published public var categories = Observer<Categorys>().objects
    @Published public var profiles = Observer<Profile>().objects
    @Published public var services = Observer<MerchantService>().objects
    @Published public var airTimeServices = [MerchantService]()
    @Published public var processedCategories = [[Categorys]]()
    @Published public var rechargeAndBill = [MerchantService]()
    @Published public var profile = Profile()
    @Published public var transactionHistory = Observer<TransactionHistory>().objects
    @Published public var dueBill = [FetchedBill]()
    @Published public var subscription = Set<AnyCancellable>()
    public var homeUsecase: HomeUsecase
    public init(homeUsecase: HomeUsecase) {
        self.homeUsecase = homeUsecase
        processedCategories = categories.reversed().reversed().chunked(into: 4)
        getProfile()
        getQuickTopups()
        displayedRechargeAndBill()
    }
    public func getProfile() {
        guard let profile = profiles.first else {
//            fatalError("No profile found")
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
        .store(in: &subscription)
        return
    }
    public func mapHistoryIntoChartData() -> [ChartData] {
        var chartDataMap = [Int:Double]()
        transactionHistory.forEach { history in
            guard let validDateString = history.paymentDate?.split(separator: ".").first else {
                fatalError("Invalid date format")
            }
            let validDate = String(validDateString)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: validDate)!
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
            promise(.success(services.prefix(8).shuffled()))
        }
        .assign(to: \.rechargeAndBill, on: self)
        .store(in: &subscription)
        return
    }
    
    public func fetchDueBills(serviceId: String, msisdn: String, clientId: String)  {
        let serviceId="FB"
        guard let profile = profiles.first else {
            fatalError("No profile found")
        }
        let msisdn = profile.msisdn
        let clientId = profile
        Task{
//            let result = try await homeUsecase(serviceId: serviceId, msisdn: msisdn, clientId: clientId)
//            dueBill = result
        }
    }
}
