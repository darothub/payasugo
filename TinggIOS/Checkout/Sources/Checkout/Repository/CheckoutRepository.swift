//
//  File.swift
//  
//
//  Created by Abdulrasaq on 16/02/2023.
//
import Core
import Foundation
public protocol CheckoutRepository {
    func raiseInvoiceRequest(request: RequestMap) async throws -> RINVResponse
    func makeFWCRequest(request: RequestMap) async throws -> DTBAccountsResponse
}

public class CheckoutRepositoryImpl: CheckoutRepository {

    private var baseRequest: TinggApiServices
    /// ``CheckoutRepositoryImpl`` initialiser
    /// - Parameters:
    ///   - baseRequest: ``BaseRequest``
    public init(baseRequest: TinggApiServices) {
        self.baseRequest = baseRequest
    }
    public func raiseInvoiceRequest(request: RequestMap) async throws ->  RINVResponse {
        try await baseRequest.result(request.encryptPayload()!)
    }
    public func makeFWCRequest(request: Core.RequestMap) async throws -> DTBAccountsResponse {
        try await baseRequest.result(request.encryptPayload()!)
    }
}


