//
//  File.swift
//  
//
//  Created by Abdulrasaq on 16/01/2023.
//

import Core

public class CheckoutUsecase {
    let checkoutRepository: CheckoutRepository
    /// ``CheckoutUsecase`` initialiser
    /// - Parameter checkoutRepository: ``CheckoutRepositoryImpl``
    public init (checkoutRepository: CheckoutRepository) {
        self.checkoutRepository = checkoutRepository
    }
    public func callAsFunction(request: RequestMap) async throws -> RINVResponse {
       try await checkoutRepository.raiseInvoiceRequest(request: request)
    }
    
    public func callAsFunction(request: RequestMap) async throws -> DTBAccountsResponse {
       try await checkoutRepository.makeFWCRequest(request: request)
    }

}

