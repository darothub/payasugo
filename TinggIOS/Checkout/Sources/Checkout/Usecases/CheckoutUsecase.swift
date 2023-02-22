//
//  File.swift
//  
//
//  Created by Abdulrasaq on 16/01/2023.
//

import Core

public class CheckoutUsecase {
    let checkoutRepository: CheckoutRepository
    let validateUsecase: ValidatePinUsecase
    let createCheckoutChannelUsecase: CreateCardChannelUsecase
    /// ``CheckoutUsecase`` initialiser
    /// - Parameter checkoutRepository: ``CheckoutRepositoryImpl``
    public init (checkoutRepository: CheckoutRepository, validatePinUseCase: ValidatePinUsecase, createCheckoutChannelUsecase: CreateCardChannelUsecase) {
        self.checkoutRepository = checkoutRepository
        self.validateUsecase = validatePinUseCase
        self.createCheckoutChannelUsecase = createCheckoutChannelUsecase
    }
    public func callAsFunction(request: RequestMap) async throws -> RINVResponse {
       try await checkoutRepository.raiseInvoiceRequest(request: request)
    }
    
    public func callAsFunction(request: RequestMap) async throws -> DTBAccountsResponse {
       try await checkoutRepository.makeFWCRequest(request: request)
    }
    
    public func callAsFunction(request: RequestMap) async throws -> BaseDTO {
        try await validateUsecase(tinggRequest: request)
    }
    
    public func callAsFunction(request: RequestMap) async throws -> CreateCardChannelResponse {
        try await createCheckoutChannelUsecase(tinggRequest: request)
    }

}

