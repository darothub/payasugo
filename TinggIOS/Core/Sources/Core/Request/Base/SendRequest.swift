//
//  SendRequest.swift
//  
//
//  Created by Abdulrasaq on 08/05/2023.
//

import Foundation
public class SendRequest {
    public let baseRequest: BaseRequest
    public init(baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    
    /// A call as function to send request with    ``RequestMap`` to the API
    /// - Returns: return Payload from the API`
    public func callAsFunction<T: BaseDTOprotocol>(request: RequestMap) async throws -> Result<T, ApiError> {
        print("Tinggrequest \(request)")
        return try await baseRequest.result(tinggRequest: request)
    }
}
