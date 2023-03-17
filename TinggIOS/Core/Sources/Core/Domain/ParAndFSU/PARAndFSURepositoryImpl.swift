//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public class PARAndFSURepositoryImpl: PARAndFSURepository {
    public var baseRequest: BaseRequest
    /// ``PARAndFSURepositoryImpl`` initialiser
    /// - Parameter baseRequest: ``BaseRequest``
    public init (baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    /// PARandFSU request
    /// - Parameter tinggRequest: PARandFSU request
    /// - Returns: - Returns: Result with ``PARAndFSUDTO`` or ``ApiError``
    public func makeParAndFsuRequest(tinggRequest: RequestMap ) async throws -> Result<FSUAndPARDTO, ApiError>{
        return try await baseRequest.result(tinggRequest: tinggRequest)
    }
}

public protocol PARAndFSURepository {
    func makeParAndFsuRequest(tinggRequest: RequestMap ) async throws -> Result<FSUAndPARDTO, ApiError>
}
