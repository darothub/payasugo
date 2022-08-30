//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//
import RealmSwift
import Foundation
public class FetchBillRepositoryImpl: FetchBillRepository {
    public var baseRequest: BaseRequest
    public init(baseRequest: BaseRequest) {
        self.baseRequest = baseRequest
    }
    fileprivate func fetchDueBillsDTO(tinggRequest: TinggRequest) async throws ->  FetchBillDTO {
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(tinggRequest: tinggRequest) { (result: Result<FetchBillDTO, ApiError>) in
                continuation.resume(with: result)
            }
        }
    }
    
    public func getDueBills(tinggRequest: TinggRequest) async throws -> [FetchedBill] {
        let dto = try await fetchDueBillsDTO(tinggRequest: tinggRequest)
        let data = dto.fetchedBills
        return data
    }
}

