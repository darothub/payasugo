//  HomeViewModel.swift
//  Created by Abdulrasaq on 24/07/2022.
import Common
import Core
import Combine
import Foundation

@MainActor
public class HomeViewModel: ObservableObject {
    @Published public var nominationInfo = Observer<Enrollment>().objects
    @Published public var airTimeServices = [MerchantService]()
    @Published public var servicesByCategory = [[Categorys]]()
    @Published public var service = MerchantService()
    @Published public var rechargeAndBill = [MerchantService]()
    @Published public var profile = Profile()
    @Published public var transactionHistory = Observer<TransactionHistory>().objects
    @Published public var dueBill = [Invoice]()
    @Published public var singleBill = Invoice()
    @Published public var savedBill = SavedBill()
    @Published var fetchBillUIModel = UIModel.nothing
    @Published var quickTopUIModel = UIModel.nothing
    @Published var categoryUIModel = UIModel.nothing
    @Published var rechargeAndBillUIModel = UIModel.nothing
    @Published var saveBillUIModel = UIModel.nothing
    @Published var uiModel = UIModel.nothing
    @Published var navigateBillDetailsView = false
    @Published public var subscriptions = Set<AnyCancellable>()

    public var homeUsecase: HomeUsecase
    public init(homeUsecase: HomeUsecase) {
        self.homeUsecase = homeUsecase
        getProfile()
        getQuickTopups()
        displayedRechargeAndBill()
        fetchDueBills()
        getServicesByCategory()
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
            ChartData(xName: ChartMonth.allCases[key], point: value)
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
    
    public func fetchDueBills()  {
        fetchBillUIModel = UIModel.loading
        Task {
            do {
                dueBill = try await homeUsecase.getDueBills()
                fetchBillUIModel = UIModel.nothing
            } catch {
                fetchBillUIModel = UIModel.error((error as? ApiError)?.localizedString ?? "Server error, please try again")
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
                uiModel = UIModel.error((error as? ApiError)?.localizedString ?? "Server error, please try again")
            }
        }
    }
    public func saveBill(tinggRequest: TinggRequest) {
        saveBillUIModel = UIModel.loading
        Task {
            do {
                print("singleBill \(singleBill)")
                savedBill = try await homeUsecase.saveBill(tinggRequest: tinggRequest, invoice: singleBill)
                let message = "Bill with reference \(savedBill.merchantAccountNumber) created"
                let content = UIModel.Content(statusMessage: message)
                saveBillUIModel = UIModel.content(content)
            } catch {
                saveBillUIModel = UIModel.error((error as? ApiError)?.localizedString ?? "Server error, please try again")
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


