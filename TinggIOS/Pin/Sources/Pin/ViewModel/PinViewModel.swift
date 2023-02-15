//
//  File.swift
//  
//
//  Created by Abdulrasaq on 19/01/2023.
//
import Combine
import Common
import Core
import Foundation
@MainActor
public class PinViewModel: ViewModel {
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
    private var usecase: PinUsecase
    public init(usecase: PinUsecase) {
        self.usecase = usecase
    }
    
    func createCardPin(tinggRequest: RequestMap) {
        uiModel = UIModel.loading
        Task {
            do {
                let success = try await usecase.createCardPin(tinggRequest: tinggRequest)
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
