//
//  File.swift
//  
//
//  Created by Abdulrasaq on 13/09/2022.
//

import Foundation
public class PostMCPUsecase {
    private var repository: EnrollmentRepository
    private var invoiceRepository: InvoiceRepository
    /// ``PostMCPUsecase`` initialiser
    /// - Parameters:
    ///   - repository: ``EnrollmentRepositoryImpl``
    ///   - invoiceRepository: ``FetchBillRepositoryImpl``
    public init(repository: EnrollmentRepository, invoiceRepository: InvoiceRepository) {
        self.repository = repository
        self.invoiceRepository = invoiceRepository
    }
    
    public func callAsFunction(bill: Bill, invoice: Invoice) -> Bill {
        let enrollment = bill.convertBillToEnrollment(accountNumber: invoice.billReference, service: .init())
        repository.saveNomination(nomination: enrollment)
        invoiceRepository.insertInvoiceInDb(invoice: invoice)
        return bill
    }
}


