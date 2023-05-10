//
//  ActivationCodeUsecase.swift
//  
//
//  Created by Abdulrasaq on 08/05/2023.
//
import Core
import Foundation

public class ActivationCodeUsecase {
    public let sendRequest: SendRequest
    public init(sendRequest: SendRequest) {
        self.sendRequest = sendRequest
    }

    public func callAsFunction(request: RequestMap) async throws ->  Result<BaseDTO, ApiError> {
        try await sendRequest(request: request)
    }
    
}
