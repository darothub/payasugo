//
//  AirtimeDI.swift
//  
//
//  Created by Abdulrasaq on 02/03/2023.
//
import Core
import Foundation
public struct AirtimeDI {
    public init() {
        //public init
    }
    
    @MainActor public static func createBuyAirtimeVM() -> BuyAirtimeViewModel {
        BuyAirtimeViewModel(airtimeUsecase: createAirtimeUsecase())
    }
    
    private static func createAirtimeUsecase() -> AirtimeUsecase {
        AirtimeUsecase(profileRepository: createProfileRepository(), merchantRepository: createMerchantServiceRepository(), categoryRepository: createCategoryRepository(), updateDefaultNetworkIdUsecase: createUpdateDefaultNetworkUsecase())
    }
    
    private static func createProfileRepository() -> ProfileRepository {
        ProfileRepositoryImpl(dbObserver: Observer<Profile>())
    }
    private static func createCategoryRepository() -> CategoryRepository {
        CategoryRepositoryImpl(dbObserver: Observer<CategoryEntity>())
    }
    private static func createMerchantServiceRepository() -> MerchantServiceRepository {
        MerchantServiceRepositoryImpl(dbObserver: Observer<MerchantService>())
    }
    private static func createUpdateDefaultNetworkUsecase() -> UpdateDefaultNetworkUsecase {
        UpdateDefaultNetworkUsecase(baseRequest: BaseRequest())
    }
}
