//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
/// Class type repository for requesting and confirming activation
public class ActivationRepositoryImpl:  ActivationRepository {
    public var baseRequest: BaseRequest
    public init (baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    public func requestForActivationCode(tinggRequest: RequestMap) async throws -> Result<BaseDTO, ApiError>{
        return try await baseRequest.result(tinggRequest: tinggRequest)
    }
    public func confirmActivationCode(tinggRequest: RequestMap, code: String) async throws -> Result<BaseDTO, ApiError>{
        return try await baseRequest.result(tinggRequest: tinggRequest)
    }
}

public protocol ActivationRepository {
    func requestForActivationCode(tinggRequest: RequestMap) async throws -> Result<BaseDTO, ApiError>
    func confirmActivationCode(tinggRequest: RequestMap, code: String) async throws -> Result<BaseDTO, ApiError>
}
