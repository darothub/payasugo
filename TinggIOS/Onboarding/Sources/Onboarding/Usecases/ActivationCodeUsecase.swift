//
//  ActivationCodeUsecase.swift
//  
//
//  Created by Abdulrasaq on 08/05/2023.
//
import Core
import Foundation

public class ActivationCodeUsecase {
    public let sendRequest: TinggApiServices
    public init(sendRequest: TinggApiServices) {
        self.sendRequest = sendRequest
    }

    public func callAsFunction(request: RequestMap) async throws ->  BaseDTO {
        try await sendRequest.result(tinggRequest: request)
    }
    
}
