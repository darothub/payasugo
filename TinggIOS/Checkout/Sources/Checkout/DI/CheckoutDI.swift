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
    
    private static func createCheckoutUsecase() -> CheckoutUsecase {
        CheckoutUsecase(
            checkoutRepository: CheckoutRepositoryImpl(baseRequest: BaseRequest()),
            validatePinUseCase: createValidatePinUsecase(),
            createCheckoutChannelUsecase: createCheckoutChannelUsecase()
        )
    }
    private static func createValidatePinUsecase() -> ValidatePinUsecase {
        ValidatePinUsecase(cardRepository: CardRepositoryImpl(baseRequest: BaseRequest()))
    }
    private static func createCheckoutChannelUsecase() -> CreateCardChannelUsecase {
        CreateCardChannelUsecase(cardRepository: CardRepositoryImpl(baseRequest: BaseRequest()))
    }
    public static func createCheckoutViewModel() -> CheckoutViewModel {
        CheckoutViewModel(usecase: createCheckoutUsecase())
    }
}
