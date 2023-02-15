//
//  File.swift
//  
//
//  Created by Abdulrasaq on 19/01/2023.
//
import Combine
import Foundation
public protocol ViewModel: ObservableObject {
    func handleResultState<T, E>(model: inout Common.UIModel, _ result: Result<T, E>)
    func observeUIModel(model: Published<UIModel>.Publisher, subscriptions: inout Set<AnyCancellable>, action: @escaping (UIModel.Content) -> Void, onError: @escaping(String) -> Void)
}

extension ViewModel {
    public func uiModelCases(uiModel: UIModel, action: @escaping (UIModel.Content) -> Void, onError: @escaping(String) -> Void = {_ in }) {
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
    public func log(message: String) {
        print("\(Self.self)->\n\(message)")
    }
}
