//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public protocol FetchBillRepository {
    func fetchDueBillsDTO(tinggRequest: TinggRequest) async throws ->  FetchBillDTO
    func getDueBills(tinggRequest: TinggRequest) async throws -> [Invoice]
    func saveBill(tinggRequest: TinggRequest) async throws -> SavedBill
    func insertInvoiceInDb(invoice: Invoice)
}
