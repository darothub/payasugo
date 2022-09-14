//
//  File.swift
//  
//
//  Created by Abdulrasaq on 12/09/2022.
//

import Foundation
public class SaveBillUsecase {
    private let fetchBillRepository: FetchBillRepository
    public init(fetchBillRepository: FetchBillRepository) {
        self.fetchBillRepository = fetchBillRepository
    }
    
    public func callAsFunction(tinggRequest: TinggRequest) async throws -> SavedBill {
        try await fetchBillRepository.saveBill(tinggRequest: tinggRequest)
    }
}
