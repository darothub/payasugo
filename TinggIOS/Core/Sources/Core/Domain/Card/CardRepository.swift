//
//  File.swift
//  
//
//  Created by Abdulrasaq on 16/01/2023.
//

import Foundation
public protocol CardRepository {
    func createPin(tinggRequest: RequestMap) async throws -> BaseDTO
    func createCardChannel(tinggRequest: RequestMap) async throws -> CreateCardChannelResponse
}

public class CardRepositoryImpl : CardRepository {
    private var baseRequest: BaseRequest
    /// ``CardRepositoryImpl`` initialiser
    /// - Parameters:
    ///   - baseRequest: ``BaseRequest``
    public init(baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    public func createPin(tinggRequest: RequestMap) async throws ->  BaseDTO {
        try await baseRequest.result(tinggRequest.encryptPayload()!)
    }
    public func createCardChannel(tinggRequest: RequestMap) async throws -> CreateCardChannelResponse {
        try await baseRequest.result(tinggRequest.encryptPayload()!)
    }
}
