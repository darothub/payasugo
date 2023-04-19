//
//  VirtualCardViewModel.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/04/2023.
//
import CoreUI
import Foundation
public class VirtualCardViewModel: ViewModel {
    @Published public var cardState: VirtualCardState = .pending
    public init() {
        //
    }
    
    public func handleResultState<T, E>(model: inout CoreUI.UIModel, _ result: Result<T, E>) where E : Error {
        //
    }
    
    
}
