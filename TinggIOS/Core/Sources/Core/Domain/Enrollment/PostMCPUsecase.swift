//
//  File.swift
//  
//
//  Created by Abdulrasaq on 13/09/2022.
//

import Foundation
public class PostMCPUsecase {
    private var repository: EnrollmentRepository
    private var invoiceRepository: FetchBillRepository
    /// ``PostMCPUsecase`` initialiser
    /// - Parameters:
    ///   - repository: ``EnrollmentRepositoryImpl``
    ///   - invoiceRepository: ``FetchBillRepositoryImpl``
    public init(repository: EnrollmentRepository, invoiceRepository: FetchBillRepository) {
        self.repository = repository
        self.invoiceRepository = invoiceRepository
    }
    
    public func callAsFunction(bill: SavedBill, invoice: Invoice) -> SavedBill {
        let enrollment = bill.convertBillToEnrollment(accountNumber: invoice.billReference)
        repository.saveNomination(nomination: enrollment)
        invoiceRepository.insertInvoiceInDb(invoice: invoice)
        return bill
    }
}

