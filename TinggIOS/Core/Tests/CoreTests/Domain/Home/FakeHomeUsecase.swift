//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//

import Foundation
import Core
class FakeHomeUsecase: HomeUsecase {
    let merchantServiceRepository: MerchantServiceRepository
    public init (merchantServiceRepository: MerchantServiceRepository) {
        self.merchantServiceRepository = merchantServiceRepository
    }
    
    func getProfile() -> Profile? {
        Profile()
    }
    
    func displayedRechargeAndBill() -> [MerchantService] {
        merchantServiceRepository.getServices().prefix(8).shuffled()
    }
    
    func fetchDueBill(tinggRequest: TinggRequest) async throws -> [FetchedBill] {
        var fetchbill = [FetchedBill]()
        return fetchbill
    }
}
