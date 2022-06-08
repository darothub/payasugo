//
//  ManualBillDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift
protocol ManualBillDao{
    func getAllLive() -> ObservedResults<ManualBill>
    func findById(manualBillId: String?) -> ManualBill?
}
