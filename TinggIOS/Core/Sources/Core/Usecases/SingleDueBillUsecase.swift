//
//  File.swift
//  
//
//  Created by Abdulrasaq on 06/09/2022.
//

import Foundation
public class SingleDueBillUsecase {
    private let fetchBillRepository: InvoiceRepository
    /// Single due bill usecase initialiser
    /// - Parameter fetchBillRepository: ``FetchBillRepositoryImpl``
    public init(fetchBillRepository: InvoiceRepository) {
        self.fetchBillRepository = fetchBillRepository
    }
    
    public func callAsFunction(tinggRequest: RequestMap) async throws -> Invoice {
        let dueBills = try await fetchBillRepository.fetchDueBills(tinggRequest: tinggRequest)
        return dueBills.fetchedBills[0].convertToInvoice()
    }
}
