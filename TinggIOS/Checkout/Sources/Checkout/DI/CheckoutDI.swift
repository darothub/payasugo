//
//  File.swift
//  
//
//  Created by Abdulrasaq on 16/01/2023.
//
import Core
import Foundation
@MainActor
public struct CheckoutDI {
    public init() {
        //public init
    }
    
    public static func createCheckoutUsecase() -> CheckoutUsecase {
        CheckoutUsecase()
    }
    public static func createCheckoutViewModel() -> CheckoutViewModel {
        CheckoutViewModel(usecase: createCheckoutUsecase())
    }
}
