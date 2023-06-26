//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation

public class DueBillsUsecase {
    private let fetchBillRepository: FetchBillRepository
    /// DueBillsUsecase initialiser
    /// - Parameter fetchBillRepository:``FetchBillRepositoryImpl`` repository for fetchbill
    public init(fetchBillRepository: FetchBillRepository) {
        self.fetchBillRepository = fetchBillRepository
    }
    
    /// A call as function to get invoices
    /// - Parameter tinggRequest: ``TinggRequest``
    /// - Returns: list of ``Invoice``
    public func callAsFunction(tinggRequest: TinggRequest) async throws -> [Invoice] {
        let fetchedBillDTO = try await fetchBillRepository.getDueBills(tinggRequest: tinggRequest)
        let fetchedBill = fetchedBillDTO.fetchedBills
        let invoices = fetchedBill.map { $0.convertToInvoice() }
        invoices.forEach { savedInvoice(invoice: $0)}
        return invoices
        
//        dueBills = dueBills.filter { bill in
//
//            let daysDiff = abs((makeDateFromString(validDateString: bill.dueDate) - Date()).day)
//            return daysDiff <= 5
//        }
//        return dueBills
    }
    public func savedInvoice(invoice: Invoice) {
        let savedInvoice = Observer<Invoice>().getEntities().first {
            $0.billReference == invoice.billReference &&
            $0.serviceID == invoice.serviceID
        }
        if savedInvoice == nil {
            Observer<Invoice>().saveEntity(obj: invoice)
        } else {
            //TODO: Update invoice
        }
    }
    public func callAsFunction(tinggRequest: RequestMap) async throws -> [DynamicInvoiceType] {
        let fetchedBillDTO = try await fetchBillRepository.fetchDueBills(tinggRequest: tinggRequest)
        let fetchedBill = fetchedBillDTO.fetchedBills
        let invoices = fetchedBill.map { $0.convertToInvoice() }
        invoices.forEach { savedInvoice(invoice: $0)}
        return fetchedBill
//        dueBills = dueBills.filter { bill in
//            Log.d(message: "\(bill.dueDate)")
//            let daysDiff = (makeDateFromString(validDateString: bill.dueDate) - Date()).day
//            Log.d(message: "\(daysDiff)")
//            let yearsDiff = (makeDateFromString(validDateString: bill.dueDate) - Date()).year
//            Log.d(message: "\(yearsDiff)")
//            return daysDiff <= -1 && yearsDiff <= 5
//        }
//        return dueBills
    }
}
