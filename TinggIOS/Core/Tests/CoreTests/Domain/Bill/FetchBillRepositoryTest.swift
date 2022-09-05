//
//  FetchBillRepositoryTest.swift
//  
//
//  Created by Abdulrasaq on 02/09/2022.
//

import XCTest
import Core

class FetchBillRepositoryTest: XCTestCase {
    var fetchBillRepository: FetchBillRepository!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fetchBillRepository = FetchBillRepositoryImpl(baseRequest: FakeBaseRequest())
    }

    func testFetchBillIsNotEmpty() async throws {
        let actual = try await fetchBillRepository.getDueBills(tinggRequest: .init())
        let notExpected = [FetchedBill]()
        XCTAssertNotEqual(actual, notExpected, "Expect \(actual) not equal \(String(describing: notExpected))")
    }
    func testFetchBillIsReturnsTwoFetchedBills() async throws {
        let result = try await fetchBillRepository.getDueBills(tinggRequest: .init())
        let actual = result.count
        let expected = 3
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
}
