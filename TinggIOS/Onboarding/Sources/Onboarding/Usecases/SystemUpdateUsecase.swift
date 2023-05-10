//
//  SystemUpdateUsecase.swift
//  
//
//  Created by Abdulrasaq on 08/05/2023.
//
import Core
import Foundation
public class SystemUpdateUsecase {
    public let sendRequest: SendRequest
    public init(sendRequest: SendRequest) {
        self.sendRequest = sendRequest
    }
    public func callAsFunction(request: RequestMap) async throws ->  Result<SystemUpdateDTO, ApiError> {
        try await sendRequest(request: request)
    }
}
