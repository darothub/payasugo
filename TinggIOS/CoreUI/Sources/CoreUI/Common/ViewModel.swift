//
//  File.swift
//  
//
//  Created by Abdulrasaq on 19/01/2023.
//
import Combine
import Foundation
public protocol ViewModel: ObservableObject {

}

extension ViewModel {
    public func uiModelCases(uiModel: UIModel, action: @escaping (UIModel.Content) -> Void, onError: @escaping(String) -> Void = {_ in
        //TODO
    }) {
        switch uiModel {
        case .content(let data):
            action(data)
            print("State: content")
        case .loading:
            print("State: loading..")
        case .error(let err):
            onError(err)
            print("State error \(err)")

        case .nothing:
            print("State: nothing")
        }
    }
    func observeUIModel(model: Published<UIModel>.Publisher, subscriptions: inout Set<AnyCancellable>, action: @escaping (UIModel.Content) -> Void, onError: @escaping(String) -> Void) {
        //TODO
    }
    public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>) {
        //TODO
    }
    public func handleResultState<T, E>(model: inout UIModel, _ result: Result<T, E>, showAlertOnSuccess: Bool) {
        //TODO
    }
    public func cancelPublishers() {
        //TODO
    }
    
}
