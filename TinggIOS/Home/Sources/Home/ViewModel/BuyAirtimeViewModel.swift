//
//  File.swift
//  
//
//  Created by Abdulrasaq on 15/12/2022.
//
import Combine
import Common
import Core
import Foundation

@MainActor
public class BuyAirtimeViewModel: ViewModel {
    @Published public var suggestedAmountModel: SuggestedAmountModel = .init()
    @Published public var favouriteEnrollmentListModel: FavouriteEnrollmentModel = .init()
    @Published public var providersListModel: ProvidersListModel = .init()
    @Published public var servicesDialogModel: ServicesDialogModel = .init()
    @Published public var service: MerchantService = sampleServices[0]
    @Published var defaultNetworkUIModel = UIModel.nothing
    @Published public var subscriptions = Set<AnyCancellable>()
    private var updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase
    public init(updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase) {
        self.updateDefaultNetworkIdUsecase = updateDefaultNetworkIdUsecase
    }
    
    func updateDefaultNetworkId(request: TinggRequest) {
        defaultNetworkUIModel = UIModel.loading
        Task {
            do {
                let result = try await updateDefaultNetworkIdUsecase(request: request)
                handleResultState(model: &defaultNetworkUIModel, (Result.success(result) as Result<Any, Error>))
                AppStorageManager.setDefaultNetwork(service: service)
            } catch {
                handleResultState(model: &defaultNetworkUIModel, Result.failure(((error as! ApiError))) as Result<Any, ApiError>)
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





