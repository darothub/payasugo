//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
import RealmSwift
import Core
public struct HomeDI {
    public static func createProfileRepository() -> ProfileRepository {
        return ProfileRepositoryImpl(baseRequest: BaseRequest(), dbObserver: Observer<Profile>())
    }
    public static func createMerchantServiceRepository() -> MerchantServiceRepository {
        return MerchantServiceRepositoryImpl(dbObserver: Observer<MerchantService>())
    }
    public static func createCategoryRepository() -> CategoryRepository {
        return CategoryRepositoryImpl(dbObserver: Observer<CategoryEntity>())
    }
    public static func createChunkedCategoriesUsecase() -> ChunkedCategoriesUsecase {
        return ChunkedCategoriesUsecase(categoryRepository: createCategoryRepository())
    }
    private static func createUpdateDefaultNetworkUsecase() -> UpdateDefaultNetworkUsecase {
        return UpdateDefaultNetworkUsecase(baseRequest: BaseRequest())
    }
    private static func createSystemUpdateUsecase() -> SystemUpdateUsecase {
        return SystemUpdateUsecase()
    }
    @MainActor
    public static func createHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            profileRepository: createProfileRepository(),
            merchantRepository: createMerchantServiceRepository(),
            chunkedCategoriesUsecase: createChunkedCategoriesUsecase(),
            updateDefaultNetworkIdUsecase: createUpdateDefaultNetworkUsecase(),
            systemUpdateUsecase: createSystemUpdateUsecase()
        )
    }
}



