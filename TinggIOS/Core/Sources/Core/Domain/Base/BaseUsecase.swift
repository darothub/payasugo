//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public protocol BaseUsecase {
    var baseRequest: BaseRequest { get }
}

extension BaseUsecase {
    func result<T: BaseDTOprotocol>(tinggRequest: TinggRequest) async throws -> Result<T, ApiError> {
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                print("Result \(result)")
                continuation.resume(returning: result)
            }
        }
    }
}
