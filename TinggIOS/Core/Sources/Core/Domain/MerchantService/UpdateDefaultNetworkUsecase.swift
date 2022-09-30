//
//  File.swift
//  
//
//  Created by Abdulrasaq on 28/09/2022.
//

import Foundation
public class UpdateDefaultNetworkUsecase {
    var baseRequest: TinggApiServices
    public init(baseRequest: TinggApiServices) {
        self.baseRequest = baseRequest
    }
    
    public func callAsFunction(request: TinggRequest) async throws -> BaseDTO {
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(tinggRequest: request) { (result: Result<BaseDTO, ApiError>) in
                continuation.resume(with: result)
            }
        }
    }
}
