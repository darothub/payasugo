//
//  BillAccountUsecaseTest.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//

import Foundation
import Core
import RealmSwift
import XCTest

class BillAccountUsecaseTest: XCTestCase {
    private var merchantServiceRepository: MerchantServiceRepository!
    private var enrollmentRepository: EnrollmentRepository!
    private var usecase: BillAccountUsecase!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        merchantServiceRepository = FakeMerchantRepository(dbObserver: .init())
        enrollmentRepository = FakeEnrollmentRepository(dbObserver: .init())
        usecase = BillAccountUsecase(merchantServiceRepository: merchantServiceRepository, enrollmentRepository: enrollmentRepository)
    }
    
    func testGetBillAccounts() {
        let accounts = usecase()
        let actual = accounts.count
        let expected = 2
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
}
