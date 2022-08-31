//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
import Core
public struct HomeDI {
    public init() {
        //public init
    }
    public static func createFetchBillRepository() -> FetchBillRepository {
        return FetchBillRepositoryImpl(baseRequest: .init())
    }
    public static func createProfileRepository() -> ProfileRepository {
        return ProfileRepositoryImpl(dbObserver: Observer<Profile>())
    }
    public static func createMerchantServiceRepository() -> MerchantServiceRepository {
        return MerchantServiceRepositoryImpl(dbObserver: Observer<MerchantService>())
    }
    public static func createHomeUsecase() -> HomeUsecase {
        return HomeUsecaseImpl(
            fetchDueBillRepository: createFetchBillRepository(),
            profileRepository: createProfileRepository(),
            merchantRepository: createMerchantServiceRepository()
        )
    }
    @MainActor
    public static func createHomeViewModel() -> HomeViewModel {
        return HomeViewModel(homeUsecase: createHomeUsecase())
    }
}
