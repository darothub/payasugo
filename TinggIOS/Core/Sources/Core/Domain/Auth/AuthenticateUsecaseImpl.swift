//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public class AuthenticateUsecaseImpl: BaseUsecase, AuthenticateUsecase {
    public var baseRequest: BaseRequest
    public init (baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    public func callAsFunction(tinggRequest: TinggRequest) async throws -> Result<BaseDTO, ApiError>{
        return try await result(tinggRequest: tinggRequest)
    }
    public func callAsFunction(tinggRequest: TinggRequest, code: String) async throws -> Result<BaseDTO, ApiError>{
        return try await result(tinggRequest: tinggRequest)
    }
}

public protocol AuthenticateUsecase {
    func callAsFunction(tinggRequest: TinggRequest) async throws -> Result<BaseDTO, ApiError>
    func callAsFunction(tinggRequest: TinggRequest, code: String) async throws -> Result<BaseDTO, ApiError>
}
