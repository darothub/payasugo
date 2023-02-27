//
//  File.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//
import Combine
import Common
import Core
import SwiftUI
@MainActor
public class CheckoutViewModel: ViewModel, CheckoutProtocol, BuyAirtimeProtocol {
    @Published public var suggestedAmountModel: SuggestedAmountModel = .init()
    @Published public var favouriteEnrollmentListModel: FavouriteEnrollmentModel = .init()
    @Published public var providersListModel: ProvidersListModel = .init()
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
    @Published public var raiseInvoiceUIModel = UIModel.nothing
    @Published public var validatePinUImodel = UIModel.nothing
    @Published public var fwcUIModel = UIModel.nothing
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
    public var isCheckout: Bool = false
    private var usecase: CheckoutUsecase
    public init(usecase: CheckoutUsecase) {
        self.usecase = usecase
    }
    public func validatePin(request: RequestMap) {
        validatePinUImodel = UIModel.loading
        Task {
            do {
                let result:BaseDTO = try await usecase(request: request)
                handleResultState(model: &validatePinUImodel, (Result.success(result) as Result<Any, Error>))
            } catch {
                handleResultState(model: &validatePinUImodel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    public func raiseInvoiceRequest(request: RequestMap)  {
        raiseInvoiceUIModel = UIModel.loading
        Task {
            do {
                let result:RINVResponse = try await usecase(request: request)
                handleResultState(model: &raiseInvoiceUIModel, (Result.success(result) as Result<Any, Error>))
            } catch {
                handleResultState(model: &raiseInvoiceUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    public func makeFWCRequest(request: RequestMap)  {
        fwcUIModel = UIModel.loading
        Task {
            do {
                let result:DTBAccountsResponse = try await usecase(request: request)
                handleResultState(model: &fwcUIModel, (Result.success(result) as Result<Any, Error>))
            } catch {
                handleResultState(model: &fwcUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
            }
        }
    }
    public func createCreditCardChannel(tinggRequest: RequestMap) {
        uiModel = UIModel.loading
        Task {
            do {
                let success: CreateCardChannelResponse = try await usecase(request: tinggRequest)
                handleResultState(model: &uiModel, Result.success(success) as Result<Any, Error>)
            } catch {
                handleResultState(model: &uiModel, Result.failure(error as! ApiError) as Result<BaseDTO, ApiError>)
            }
        }

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
                content = UIModel.Content(data: data, statusMessage: (data as! BaseDTOprotocol).statusMessage)
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