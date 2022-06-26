//
//  EnrollmentDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol EnrollmentDao {
    func getAllLive() -> ObservedResults<Enrollment>
    func getAllWithInvoiceLive() -> ObservedResults<Enrollment>
    func getAllAirtimeEnrollmentsByServiceLive(hubServiceId: String?) -> ObservedResults<Enrollment>
    func getByServiceIdLive(hubServiceId: String?) -> ObservedResults<Enrollment>
    func getAllByCategoryIdLive(categoryId: String?) -> ObservedResults<Enrollment>
    func getAllWithInvoice() -> ObservedResults<Enrollment>
    func findByAccountNumber(accountNumber: String, hubServiceId: String) -> Enrollment?
    func getAllByAccountsByServiceIdLive(hubServiceId: String) -> ObservedResults<Enrollment>
    func countByServiceId(hubServiceId: String) -> Int
}
