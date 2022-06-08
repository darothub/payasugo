//
//  MerchantServiceDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol MerchantServiceDao {
    func findByServiceId(serviceId: String?) -> MerchantService?
    func getAllNonCyclic() -> List<MerchantService>
    func getAllLive() -> ObservedResults<MerchantService>
    func getAllActiveLive() -> ObservedResults<MerchantService>
    func getAllQuickTopUpsLive() -> ObservedResults<MerchantService>
    func getAllRechargesLive() -> ObservedResults<MerchantService>
    func filterActiveLive(filter: String) -> ObservedResults<MerchantService>
    func getAllActiveAirtimeServicesLive() -> ObservedResults<MerchantService>
    func findByServiceCode(serviceCode: String?) -> MerchantService?
}
