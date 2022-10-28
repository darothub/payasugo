//
//  AllRechargeUsecasTest.swift
//  
//
//  Created by Abdulrasaq on 15/09/2022.
//
import Core
import XCTest

final class AllRechargeUsecasTest: XCTestCase {
    private var serviceRepository: MerchantServiceRepository!
    private var categoryRepository: CategoryRepository!
    private var usecase: CategoriesAndServicesUsecase!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        serviceRepository = FakeMerchantRepository(dbObserver: Observer<MerchantService>())
        categoryRepository = FakeCategoryRepository(dbObserver: Observer<Categorys>())
        usecase = CategoriesAndServicesUsecase(serviceRepository: serviceRepository, categoryRepository: categoryRepository)
    }
    
    func testAllRechargeUsecase() {
        let dict = usecase()
        let services = dict["PayTV"]
        let service = services![0]
        let actual = service.categoryID
        let expected = "2"
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
}
