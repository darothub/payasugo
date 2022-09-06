//
//  File.swift
//  
//
//  Created by Abdulrasaq on 06/09/2022.
//

import Foundation
public class SingleDueBillUsecase {
    private let fetchBillRepository: FetchBillRepository
    public init(fetchBillRepository: FetchBillRepository) {
        self.fetchBillRepository = fetchBillRepository
    }
    
    public func callAsFunction(tinggRequest: TinggRequest) async throws -> FetchedBill {
        let dueBills = try await fetchBillRepository.getDueBills(tinggRequest: tinggRequest)
        return dueBills[0]
    }
}
