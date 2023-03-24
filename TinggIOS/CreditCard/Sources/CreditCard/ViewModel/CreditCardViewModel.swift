//
//  File.swift
//  
//
//  Created by Abdulrasaq on 25/01/2023.
//
import Combine
import CoreUI
import Core
import Foundation
import Alamofire
import Checkout
@MainActor
public class CreditCardViewModel: ViewModel, CheckoutProtocol {
    @Published public var slm: ServicesListModel = .init()
    @Published public var sam: SuggestedAmountModel = .init()
    @Published public var fem: FavouriteEnrollmentModel = .init()
    @Published public var dcm: DebitCardModel = .init()
    @Published public var dcddm: DebitCardDropDownModel = .init()
    @Published public var cardDetails: CardDetails = .init()
    @Published public var showCardOptions: Bool = false
    @Published public var showCheckOutView: Bool = false
    @Published public var service: MerchantService = sampleServices[0]
    @Published public var isSomeoneElsePaying: Bool = false
    @Published public var selectedMerchantPayerName: String = ""
    @Published public var addNewCard = false
    @Published public var uiModel = UIModel.nothing
    @Published public var showAlert = false
    @Published public var pinPermission: String = ""
    @Published public var pin: String = ""
    @Published public var confirmPin: String = ""
    @Published public var createdPin = false
    @Published public var showCardPinView = false
    @Published public var pinIsCreated: Bool = false
    @Published public var showSecurityQuestionView = false
    @Published public var questions:[String] = .init()
    @Published public var selectedQuestion:String = ""
    @Published public var answer:String = ""
    @Published public var subscriptions = Set<AnyCancellable>()
    let creditCardUsecases: CreditCardUsecases
    
    public init( creditCardUsecases: CreditCardUsecases) {
        self.creditCardUsecases = creditCardUsecases
    }
    
    public func createCreditCardChannel(tinggRequest: RequestMap) async throws  {
        uiModel = UIModel.loading
        do {
            let success = try await creditCardUsecases.createCardChannel(tinggRequest: tinggRequest)
            handleResultState(model: &uiModel, Result.success(success) as Result<Any, Error>)
        } catch {
            handleResultState(model: &uiModel, Result.failure(error as! ApiError) as Result<BaseDTO, ApiError>)
        }
       
    }
    /// Handle result
    nonisolated public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>) where E : Error {
        switch result {
        case .failure(let apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case .success(let data):
            var content: UIModel.Content
            if let d = data as? BaseDTOprotocol {
                content = UIModel.Content(data: data, statusMessage: d.statusMessage)
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
