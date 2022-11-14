//
//  File.swift
//  
//
//  Created by Abdulrasaq on 12/09/2022.
//

import Foundation
public class SaveBillUsecase {
    private let fetchBillRepository: FetchBillRepository
    /// Save bills
    /// - Parameter fetchBillRepository: ``FetchBillRepositoryImpl``
    public init(fetchBillRepository: FetchBillRepository) {
        self.fetchBillRepository = fetchBillRepository
    }
    
    public func callAsFunction(tinggRequest: TinggRequest) async throws -> Bill {
        try await fetchBillRepository.saveBill(tinggRequest: tinggRequest)
    }
}
