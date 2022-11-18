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
    
    public func callAsFunction(bill: Bill, invoice: Invoice) -> Bill {
        let enrollment = bill.convertBillToEnrollment(accountNumber: invoice.billReference, service: .init())
        repository.saveNomination(nomination: enrollment)
        invoiceRepository.insertInvoiceInDb(invoice: invoice)
        return bill
    }
}


public class MCPDeleteAndUpdateUsecase {
    private var deleteUsecase: DeleteBillUsecase
    private var updateUsecase: UpdateBillUsecase
    private var repopository: FetchBillRepository
    public init(repository: FetchBillRepository) {
        self.repopository = repository
        self.deleteUsecase = DeleteBillUsecase(fetchBillRepository: repository)
        self.updateUsecase = UpdateBillUsecase(fetchBillRepository: repository)
    }
    
    public func callAsFunction(request: TinggRequest) async throws -> BaseDTO {
        if request.action == MCPAction.DELETE.rawValue {
            return try await deleteUsecase(tinggRequest: request)
        } else {
            return try await updateUsecase(tinggRequest: request)
        }
    }
}
