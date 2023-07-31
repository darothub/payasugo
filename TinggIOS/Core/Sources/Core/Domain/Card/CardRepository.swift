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
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(parameters: tinggRequest.encryptPayload()!) { result in
                continuation.resume(with: result)
            }
        }
    }
    public func createCardChannel(tinggRequest: RequestMap) async throws -> CreateCardChannelResponse {
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(parameters: tinggRequest.encryptPayload()!) { result in
                continuation.resume(with: result)
            }
        }
    }
}
