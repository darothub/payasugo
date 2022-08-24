//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public class PARAndFSUUsecaseImpl: BaseUsecase, PARAndFSUUsecase {
    public var baseRequest: BaseRequest
    var tinggRequest: TinggRequest = .init()
    public init (baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    public func callAsFunction(msisdn: String, clientId: String) async throws -> Result<PARAndFSUDTO, ApiError>{
        let activeCountry = AppStorageManager.getActiveCountry()
        tinggRequest.makePARRequest(dataSource: activeCountry, msisdn: msisdn, clientId: clientId)
        return try await result(tinggRequest: tinggRequest)
    }
}

public protocol PARAndFSUUsecase {
    func callAsFunction(msisdn: String, clientId: String) async throws -> Result<PARAndFSUDTO, ApiError>
}
