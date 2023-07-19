//
//  File.swift
//  
//
//  Created by Abdulrasaq on 04/07/2023.
//

import Foundation
import Core
protocol GetSingleBillUsecase {
    func callAsFunction(request: RequestMap) async throws -> Invoice
}

class GetSingleBillUsecaseImpl: GetSingleBillUsecase {
    
    private let fetchBillRepository: InvoiceRepository
    /// Single due bill usecase initialiser
    /// - Parameter fetchBillRepository: ``FetchBillRepositoryImpl``
    public init(fetchBillRepository: InvoiceRepository) {
        self.fetchBillRepository = fetchBillRepository
    }
    
    public func callAsFunction(request: RequestMap) async throws -> Invoice {
        let dueBills = try await fetchBillRepository.fetchDueBills(tinggRequest: request)
        return dueBills.fetchedBills[0].convertToInvoice()
    }
}
