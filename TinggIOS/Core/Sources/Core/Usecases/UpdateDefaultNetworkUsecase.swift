//
//  UpdateDefaultNetworkUsecase.swift
//  
//
//  Created by Abdulrasaq on 28/09/2022.
//

import Foundation
public class UpdateDefaultNetworkUsecase {
    var baseRequest: TinggApiServices
    /// ``UpdateDefaultNetworkUsecase`` initialiser
    /// - Parameter baseRequest: ``BaseRequest``
    public init(baseRequest: TinggApiServices) {
        self.baseRequest = baseRequest
    }
    
    /// A call as function to update the default network
    /// - Parameter request: UPN request
    /// - Returns: ``BaseDTO``
    public func callAsFunction(request: TinggRequest) async throws -> BaseDTO {
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(tinggRequest: request) { (result: Result<BaseDTO, ApiError>) in
                continuation.resume(with: result)
            }
        }
    }
    /// A call as function to update the default network
    /// - Parameter request: UPN request
    /// - Returns: ``BaseDTO``
    public func callAsFunction(request: RequestMap) async throws -> BaseDTO {
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(tinggRequest: request) { (result: Result<BaseDTO, ApiError>) in
                continuation.resume(with: result)
            }
        }
    }
}
