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
    @Published var uiModel = UIModel.nothing
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
    private var usecase: CheckoutUsecase
    public init(usecase: CheckoutUsecase) {
        self.usecase = usecase
    }
    
    /// Handle result
    public func handleResultState<T, E>(model: inout Common.UIModel, _ result: Result<T, E>) where E : Error {
        switch result {
        case .failure(let apiError):
            model = UIModel.error((apiError as! ApiError).localizedString)
            return
        case .success(let data):
            var content: UIModel.Content
            if data is BaseDTOprotocol {
                content = UIModel.Content(data: data, statusMessage: (data as! BaseDTO).statusMessage)
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
