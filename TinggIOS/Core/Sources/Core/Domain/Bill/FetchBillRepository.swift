//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
/// Protocol that defines operations for bills
public protocol FetchBillRepository {
    func getDueBills(tinggRequest: TinggRequest) async throws -> [Invoice]
    func saveBill(tinggRequest: TinggRequest) async throws -> SavedBill
    func insertInvoiceInDb(invoice: Invoice)
}
