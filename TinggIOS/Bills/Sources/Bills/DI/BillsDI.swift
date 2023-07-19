//
//  BillsDI.swift
//  
//
//  Created by Abdulrasaq on 04/07/2023.
//
import Core
import Foundation
public struct BillsDI {
    
    private static func createFetchBillRepository() -> InvoiceRepository {
        FetchBillRepositoryImpl(baseRequest: BaseRequest(), dbObserver: .init())
    }
    private static func createGetSingleBillUsecase() -> GetSingleBillUsecase {
        GetSingleBillUsecaseImpl(fetchBillRepository: createFetchBillRepository())
    }
    private static func createMCPusecase() -> MCPUsecase {
        MCPUsecaseImpl()
    }
    
    private static func createGetDueBillsUsecase() -> GetDueBillUsecase {
        GetDueBillUsecaseImpl(
            merchantServiceRepository: createMerchantServiceRepository(),
            enrollmentRepository: createEnrollmentRepository(),
            invoiceRepository: createFetchBillRepository()
        )
    }
    private static func createGetCategoriesAndServicesUsecase() -> CategoriesAndServicesUsecase {
        CategoriesAndServicesUsecaseImpl(
            serviceRepository: createMerchantServiceRepository(),
            categoryRepository: createCategoryRepository()
        )
    }
    private static func createBarChartUsecase() -> BarChartUsecase {
        BarChartUsecaseImpl(transactHistoryRepository: createTransactionHistoryRepository())
    }
    private static func createMerchantServiceRepository() -> MerchantServiceRepository {
        MerchantServiceRepositoryImpl(dbObserver: .init())
    }
    
    private static func createEnrollmentRepository() -> EnrollmentRepository {
        EnrollmentRepositoryImpl(dbObserver: .init())
    }
    
    private static func createCategoryRepository() -> CategoryRepository {
        CategoryRepositoryImpl(dbObserver: .init())
    }
    private static func createTransactionHistoryRepository() -> TransactionHistoryRepository {
        TransactionHistoryImpl(dbObserver: .init())
    }
    
    @MainActor
    static func createBillViewModel() -> BillViewModel {
        BillViewModel(
            getSingleBillUsecase: createGetSingleBillUsecase(),
            mcpUsecase: createMCPusecase(),
            getDueBillUsecase: createGetDueBillsUsecase(),
            getCategoriesAndServicesUsecase: createGetCategoriesAndServicesUsecase(),
            getBarChartDataUsecase: createBarChartUsecase()
        )
    }
    
}
