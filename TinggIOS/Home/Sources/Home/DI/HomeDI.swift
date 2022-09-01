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
    public static func createBaseRepository<T: BaseRepository>() -> T where T.O : Object, T.O: ObjectKeyIdentifiable  {
        let impl = BaseRepositoryImpl<T.O>(dbObserver: .init())
        return impl as! T
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
    public static func createCategoryRepository() -> CategoryRepository {
        return CategoryRepositoryImpl(dbObserver: Observer<Categorys>())
    }
    public static func createEnrollmentRepository() -> EnrollmentRepository {
        return EnrollmentRepositoryImpl(dbObserver: Observer<Enrollment>())
    }
    public static func createFetchdBillRepository() -> FetchBillRepository {
        return FetchBillRepositoryImpl(baseRequest: .init())
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
    
    public static func createBillAccountUsecase() -> BillAccountUsecase {
        return BillAccountUsecase(
            merchantServiceRepository: createMerchantServiceRepository(),
            enrollmentRepository: createEnrollmentRepository()
        )
    }
    
    public static func createDueBillUsecase() -> DueBillsUsecase {
        return DueBillsUsecase(
            billAccountUseCase: createBillAccountUsecase(),
            fetchBillRepository: createFetchBillRepository()
        )
    }
    
    public static func createHomeUsecase() -> HomeUsecase {
        return HomeUsecase(
            fetchDueBillRepository: createFetchBillRepository(),
            profileRepository: createProfileRepository(),
            merchantRepository: createMerchantServiceRepository(),
            categoryRepository: createCategoryRepository(),
            chunkedCategoriesUsecase: createChunkedCategoriesUsecase(),
            barChartUsecase: createBarChartUsecase(),
            dueBillsUsecase: createDueBillUsecase()
        )
    }
    @MainActor
    public static func createHomeViewModel() -> HomeViewModel {
        return HomeViewModel(homeUsecase: createHomeUsecase())
    }
}
