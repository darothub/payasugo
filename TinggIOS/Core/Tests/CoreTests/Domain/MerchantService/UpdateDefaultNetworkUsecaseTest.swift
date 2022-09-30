//
//  UpdateDefaultNetworkUsecase.swift
//  
//
//  Created by Abdulrasaq on 30/09/2022.
//
import Core
import XCTest

final class UpdateDefaultNetworkUsecase: XCTestCase {

    private var serviceRepository: MerchantServiceRepository!
    private var usecase: UpdateDefaultNetworkUsecase!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        serviceRepository = FakeMerchantRepository(dbObserver: Observer<MerchantService>())
        usecase = UpdateDefaultNetworkUsecase(
    }


}
