//
//  CheckoutViewModel.swift
//  
//
//  Created by Abdulrasaq on 15/01/2023.
//
import Combine
import CoreUI
import Core
import SwiftUI
public class CheckoutViewModel: ViewModel  {
    @Published public var sam: SuggestedAmountModel = .init()
    @Published public var fem: FavouriteEnrollmentModel = .init()
    @Published public var slm: ServicesListModel = .init()
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
    @Published public var showView = false
    @Published public var enrollment: Enrollment = .init()
    @Published public var amount: String = ""
    @Published public var accountNumber: String = ""
    let c = CurrentValueSubject<UIModel, Never>(.nothing)
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
                handleResultState(model: &validatePinUImodel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &validatePinUImodel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
            }
        }
    }
    @MainActor
    public func raiseInvoiceRequest(request: RequestMap)  {
        raiseInvoiceUIModel = UIModel.loading
        Task {
            do {
                let result:RINVResponse = try await usecase(request: request)
                handleResultState(model: &raiseInvoiceUIModel, (Result.success(result) as Result<Any, Error>), showAlertOnSuccess: true)
            } catch {
                handleResultState(model: &raiseInvoiceUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
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
                handleResultState(model: &fwcUIModel, Result.failure(error as! ApiError) as Result<Any, ApiError>)
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
