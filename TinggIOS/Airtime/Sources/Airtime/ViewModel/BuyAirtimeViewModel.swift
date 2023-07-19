//
//  File.swift
//  
//
//  Created by Abdulrasaq on 15/12/2022.
//
import Combine
import CoreUI
import Contacts
import Core
import Checkout
import Foundation
import Permissions

public class BuyAirtimeViewModel: ViewModel {
    @Published var oldBeneficiaries = [PreviousBeneficiaryModel]()
    @Published var copyOfOldBeneficiaries = [PreviousBeneficiaryModel]()
    @Published var currentPhoneNumber = ""
    @Published var myPhoneNumber = AppStorageManager.getPhoneNumber()
    @Published var selectedAmount = ""
    @Published var amountHistory = [String]()
    @Published var uiModel = UIModel.nothing
    @Published var whoseNumber = WhoseNumberLabel.none
    @Published var networkList: [NetworkItem] = []
    @Published var permission = ContactManager()
    @Published var slm: ServicesListModel = .init()
    @Published var enrollments = [Enrollment]()
    @Published public var currentService: MerchantService = sampleServices[0]
    @Published public var defaultService: MerchantService = sampleServices[0]
    @Published public var quickTopUIModel = UIModel.nothing
    @Published var defaultNetworkUIModel = UIModel.nothing
    @Published public var subscriptions = Set<AnyCancellable>()
    public var history: [TransactionHistory] = Observer<TransactionHistory>().getEntities()
    public var currentCountry = AppStorageManager.getCountry()
    public var currency: String {
        currentCountry?.currency ?? "NA"
    }
    public var countryMobileRegex: String {
        currentCountry?.countryMobileRegex ?? ""
    }
    var realmManager = RealmManager()
    private var airtimeUsecase: AirtimeUsecase
    public init(airtimeUsecase: AirtimeUsecase) {
        self.airtimeUsecase = airtimeUsecase
    }
    public func getQuickTopups() -> [MerchantService] {
        quickTopUIModel = UIModel.loading
        let quicktopups = airtimeUsecase.getQuickTopups()
        handleResultState(model: &quickTopUIModel, (Result.success(quicktopups) as Result<Any, Error>))
        return quicktopups
    }
    @MainActor
    func updateDefaultNetworkId(request: RequestMap) {
        defaultNetworkUIModel = UIModel.loading
        Task {
            do {
                let result = try await airtimeUsecase.updateDefaultNetwork(request: request)
                handleResultState(model: &defaultNetworkUIModel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &defaultNetworkUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }

    }
    func fetchPhoneContacts(action: @escaping (CNContact) -> Void, onError: @escaping (String) -> Void ) async {
        Task {
           await self.permission.fetchContacts {[unowned self] result in
                switch result {
                case .failure(let error):
                    onError(error.localizedDescription)
                    uiModel = UIModel.error(error.localizedDescription)
                case .success(let contacts):
                    action(contacts)
                }
            }
        }
        
    }
    func getServiceByServiceName(_ name: String) -> MerchantService {
        Observer<MerchantService>().getEntities().first { $0.serviceName == name }!
    }
    
    func getAirtimeServices() -> [MerchantService] {
        Observer<MerchantService>().getEntities().filter {$0.isAirtimeService}
    }
    func getEnrollments(to service: MerchantService) -> [Enrollment] {
        let nomination = filterNomination(by: service)
        return nomination.map({ e in
            if (e.accountNumber == currentPhoneNumber) && (e.accountAlias.isEmpty) {
                realmManager.realmWrite {
                    e.accountAlias = "Me"
                }
            }
            return e
        })
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


struct PreviousBeneficiaryModel {
    var id:String {
        UUID().uuidString
    }
    var name: String = ""
    var phoneNumber: String = ""
}


