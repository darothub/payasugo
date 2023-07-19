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
    public init() {
        //public init
    }

    public static func createFetchBillRepository() -> InvoiceRepository {
        return FetchBillRepositoryImpl(baseRequest: BaseRequest(), dbObserver: Observer<Invoice>())
    }
    public static func createProfileRepository() -> ProfileRepository {
        return ProfileRepositoryImpl(baseRequest: BaseRequest(), dbObserver: Observer<Profile>())
    }
    public static func createMerchantServiceRepository() -> MerchantServiceRepository {
        return MerchantServiceRepositoryImpl(dbObserver: Observer<MerchantService>())
    }
    public static func createCategoryRepository() -> CategoryRepository {
        return CategoryRepositoryImpl(dbObserver: Observer<CategoryEntity>())
    }
    public static func createEnrollmentRepository() -> EnrollmentRepository {
        return EnrollmentRepositoryImpl(dbObserver: Observer<Enrollment>())
    }
 
    public static func createChunkedCategoriesUsecase() -> ChunkedCategoriesUsecase {
        return ChunkedCategoriesUsecase(categoryRepository: createCategoryRepository())
    }
    public static func createTransactionHistoryRepository() -> TransactionHistoryRepository{
        return TransactionHistoryImpl(dbObserver: Observer<TransactionHistory>())
    }
    public static func createBarChartUsecase() -> BarChartUsecase {
        return BarChartUsecase(transactHistoryRepository: createTransactionHistoryRepository())
    }
    
    private static func createBillAccountUsecase() -> BillAccountUsecase {
        return BillAccountUsecase(
            merchantServiceRepository: createMerchantServiceRepository(),
            enrollmentRepository: createEnrollmentRepository()
        )
    }
    
    private static func createDueBillUsecase() -> DueBillsUsecase {
        return DueBillsUsecase(
            fetchBillRepository: createFetchBillRepository()
        )
    }
    
    private static func createSingleDueBillUsecase() -> SingleDueBillUsecase {
        return SingleDueBillUsecase(
            fetchBillRepository: createFetchBillRepository()
        )
    }
    
    private static func createSaveBillUsecase() -> SaveBillUsecase {
        return SaveBillUsecase(
            fetchBillRepository: createFetchBillRepository()
        )
    }
    
    private static func createPostMCPUsecase() -> PostMCPUsecase {
        return PostMCPUsecase(
            repository: createEnrollmentRepository(),
            invoiceRepository: createFetchBillRepository()
        )
    }
    
    private static func createCategoriesAndServicesUsecase() -> CategoriesAndServicesUsecase {
        return CategoriesAndServicesUsecase(
            serviceRepository: createMerchantServiceRepository(),
            categoryRepository: createCategoryRepository()
        )
    }
    private static func createUpdateDefaultNetworkUsecase() -> UpdateDefaultNetworkUsecase {
        return UpdateDefaultNetworkUsecase(baseRequest: BaseRequest())
    }
    
    private static func createMCPDeleteAndUpdateUsecase() -> MCPDeleteAndUpdateUsecase {
        return MCPDeleteAndUpdateUsecase(repository: createFetchBillRepository())
    }
    private static func createSystemUpdateUsecase() -> SystemUpdateUsecase {
        return SystemUpdateUsecase(sendRequest: .shared)
    }
    @MainActor private static func createHomeUsecase() -> HomeUsecase {
        return HomeUsecase(
            billAccountUsecase: createBillAccountUsecase(),
            profileRepository: createProfileRepository(),
            merchantRepository: createMerchantServiceRepository(),
            categoryRepository: createCategoryRepository(),
            chunkedCategoriesUsecase: createChunkedCategoriesUsecase(),
            barChartUsecase: createBarChartUsecase(),
            dueBillsUsecase: createDueBillUsecase(),
            singleDueBillUsecase: createSingleDueBillUsecase(),
            saveBillUsecase:  createSaveBillUsecase(),
            mcpDeleteAndUpdateUsecase: createMCPDeleteAndUpdateUsecase(),
            categoriesAndServicesUsecase: createCategoriesAndServicesUsecase(),
            updateDefaultNetworkIdUsecase: createUpdateDefaultNetworkUsecase(),
            systemUpdateUsecase: createSystemUpdateUsecase()
        )
    }
    @MainActor
    public static func createHomeViewModel() -> HomeViewModel {
        return HomeViewModel(homeUsecase: createHomeUsecase())
    }
}



