//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public class AuthenticateRepositoryImpl:  AuthenticateRepository {
    public var baseRequest: BaseRequest
    public init (baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    public func requestForActivationCode(tinggRequest: TinggRequest) async throws -> Result<BaseDTO, ApiError>{
        return try await baseRequest.result(tinggRequest: tinggRequest)
    }
    public func confirmActivationCode(tinggRequest: TinggRequest, code: String) async throws -> Result<BaseDTO, ApiError>{
        return try await baseRequest.result(tinggRequest: tinggRequest)
    }
}

public protocol AuthenticateRepository {
    func requestForActivationCode(tinggRequest: TinggRequest) async throws -> Result<BaseDTO, ApiError>
    func confirmActivationCode(tinggRequest: TinggRequest, code: String) async throws -> Result<BaseDTO, ApiError>
}
