//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public class AuthenticateUsecaseImpl: BaseUsecase, AuthenticateUsecase {
    public var baseRequest: BaseRequest
    var tinggRequest: TinggRequest = .init()
    public init (baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    public func callAsFunction(msisdn: String, clientId: String) async throws -> Result<BaseDTO, ApiError>{
        tinggRequest.getActivationCode(service: "MAK", msisdn: msisdn, clientId: clientId)
        return try await result(tinggRequest: tinggRequest)
    }
    public func callAsFunction(msisdn: String, clientId: String, code: String) async throws -> Result<BaseDTO, ApiError>{
        tinggRequest.confirmActivationCode(
            service: "VAK",
            msisdn: msisdn,
            clientId: clientId,
            code: code
        )
        return try await result(tinggRequest: tinggRequest)
    }
}

public protocol AuthenticateUsecase {
    func callAsFunction(msisdn: String, clientId: String) async throws -> Result<BaseDTO, ApiError>
    func callAsFunction(msisdn: String, clientId: String, code: String) async throws -> Result<BaseDTO, ApiError>
}
