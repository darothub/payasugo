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
    public init(baseRequest: TinggApiServices = BaseRequest.shared) {
        self.baseRequest = baseRequest
    }
    
    /// A call as function to update the default network
    /// - Parameter request: UPN request
    /// - Returns: ``BaseDTO``
    public func callAsFunction(request: RequestMap) async throws -> BaseDTO {
        try await baseRequest.result(request.encryptPayload()!)
    }
}
