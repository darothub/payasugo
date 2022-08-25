//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation

public class FetchDueBillUsecaseImpl: FetchDueBillUsecase {
    let fetchBillRepository: FetchBillRepository
    public init(fetchBillRepository: FetchBillRepository){
        self.fetchBillRepository = fetchBillRepository
    }
    public func callAsFunction(tinggRequest: TinggRequest) async throws -> [FetchedBill]{
        return try await fetchBillRepository.getDueBills(tinggRequest: tinggRequest)
    }
}

public protocol FetchDueBillUsecase {
    func callAsFunction(tinggRequest: TinggRequest) async throws -> [FetchedBill]
}
