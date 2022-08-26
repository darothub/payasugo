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
    public static func createFetchBillUsecase() -> FetchDueBillUsecase {
        return FetchDueBillUsecaseImpl(fetchBillRepository: createFetchBillRepository())
    }
    public static func createHomeUsecase() -> HomeUsecase {
        return HomeUsecaseImpl(fetchDueBillUsecase: createFetchBillUsecase())
    }
    @MainActor
    public static func createHomeViewModel() -> HomeViewModel {
        return HomeViewModel(homeUsecase: createHomeUsecase())
    }
}
