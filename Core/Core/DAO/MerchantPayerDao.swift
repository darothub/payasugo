//
//  MerchantPayerDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol MerchantPayerDao {
    func fundMerchantPayerByClientId(clientId: String?) -> MerchantPayer?
    func fundMerchantPayerByServiceCode(serviceCode: String?) -> MerchantPayer?
    func getAllActiveLive() -> ObservedResults<MerchantPayer>
    func getAllSelectedLive() -> ObservedResults<MerchantPayer>
    func getAllManualBillPayersLive() -> ObservedResults<MerchantPayer>
}
