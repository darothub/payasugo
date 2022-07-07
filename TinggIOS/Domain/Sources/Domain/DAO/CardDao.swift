//
//  CardDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift
protocol CardDao {
    func getAllNormalActiveLive()-> ObservedResults<Card>
    func getAllNormalActiveByPayerIdLive(payerClientId: String?) -> ObservedResults<Card>
    func getAllVirtualCardAlias() -> String?
    func getAllVirtualCardStatusAlias() -> String?
    func updateCardStatus(activeStatus: String)
    func deleteByType(type: String?)
}
