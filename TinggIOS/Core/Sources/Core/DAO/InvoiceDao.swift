//
//  InvoiceDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol InvoiceDao {
    func getAllHomePageBillsLive() -> ObservedResults<Invoice>
    func getAllNonCyclic() -> List<Invoice>
    func findByAccountNumber(accountNumber: String?, hubServiceId: String?) -> Invoice?
    func findByAccountNumberLive(accountNumber: String?, hubServiceId: String?) -> ObservedResults<Invoice>
    func findByBeepId(beepId: String?) -> Invoice?
    func deleteAllNonCyclic()
}
