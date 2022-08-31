//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
public class HomeUsecaseImpl: HomeUsecase {
    private var fetchDueBillRepository: FetchBillRepository
    private var profileRepository: ProfileRepository
    private var merchantRepository: MerchantServiceRepository
    public init(
        fetchDueBillRepository: FetchBillRepository,
        profileRepository: ProfileRepository,
        merchantRepository: MerchantServiceRepository
    ){
        self.fetchDueBillRepository = fetchDueBillRepository
        self.profileRepository = profileRepository
        self.merchantRepository = merchantRepository
    }
    public func fetchDueBill(tinggRequest: TinggRequest) async throws -> [FetchedBill] {
        return try await fetchDueBillRepository.getDueBills(tinggRequest: tinggRequest)
    }
    public func getProfile() -> Profile? {
        profileRepository.getProfile()
    }
    public func displayedRechargeAndBill() -> [MerchantService] {
        merchantRepository.getServices().prefix(8).shuffled()
    }
}



public protocol HomeUsecase {
    func fetchDueBill(tinggRequest: TinggRequest) async throws -> [FetchedBill]
    func getProfile() -> Profile?
    func displayedRechargeAndBill() -> [MerchantService]
}
