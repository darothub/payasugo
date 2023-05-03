//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
/// Protocol that defines operations for bills
public protocol FetchBillRepository {
    func getDueBills(tinggRequest: TinggRequest) async throws -> FetchBillDTO
    func saveBill(tinggRequest: TinggRequest) async throws -> Bill
    func deleteBill(tinggRequest: TinggRequest) async throws -> BaseDTO
    func updateBill(tinggRequest: TinggRequest) async throws -> BaseDTO
    func insertInvoiceInDb(invoice: Invoice)
    func fetchDueBills(tinggRequest: RequestMap) async throws -> FetchBillDTO
}
