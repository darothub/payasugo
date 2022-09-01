//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public class PARAndFSURepositoryImpl: PARAndFSURepository {
    public var baseRequest: BaseRequest
    public init (baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    public func makeParAndFsuRequest(tinggRequest: TinggRequest ) async throws -> Result<PARAndFSUDTO, ApiError>{
        return try await baseRequest.result(tinggRequest: tinggRequest)
    }
}

public protocol PARAndFSURepository {
    func makeParAndFsuRequest(tinggRequest: TinggRequest ) async throws -> Result<PARAndFSUDTO, ApiError>
}
