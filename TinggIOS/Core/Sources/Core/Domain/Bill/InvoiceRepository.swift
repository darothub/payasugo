//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
/// Protocol that defines operations for bills
public protocol InvoiceRepository {
    func getDueBills(tinggRequest: RequestMap) async throws -> FetchBillDTO
    func saveBill(tinggRequest: RequestMap) async throws -> Bill
    func deleteBill(tinggRequest: RequestMap) async throws -> BaseDTO
    func updateBill(tinggRequest: RequestMap) async throws -> BaseDTO
    func insertInvoiceInDb(invoice: Invoice)
    func fetchDueBills(tinggRequest: RequestMap) async throws -> FetchBillDTO
}

public extension InvoiceRepository {
    func getInvoices() -> [Invoice] {
        Observer<Invoice>().getEntities()
    }
}
