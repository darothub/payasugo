//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public class PARAndFSUUsecaseImpl: BaseUsecase, PARAndFSUUsecase {
    public var baseRequest: BaseRequest
    public init (baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    public func callAsFunction(tinggRequest: TinggRequest ) async throws -> Result<PARAndFSUDTO, ApiError>{
        return try await result(tinggRequest: tinggRequest)
    }
}

public protocol PARAndFSUUsecase {
    func callAsFunction(tinggRequest: TinggRequest ) async throws -> Result<PARAndFSUDTO, ApiError>
}
