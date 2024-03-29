//
//  File.swift
//  
//
//  Created by Abdulrasaq on 02/09/2022.
//

import XCTest
import Core
class DueBillUsecaseTest: XCTestCase {
    var fetchBillRepository: InvoiceRepository!
    var dueBillUsecase: DueBillsUsecase!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fetchBillRepository = FetchBillRepositoryImpl(baseRequest: FakeBaseRequest(), dbObserver: Observer<Invoice>())
        dueBillUsecase = DueBillsUsecase(fetchBillRepository: fetchBillRepository)
        
    }
    
    func testDueBillOfFiveDaysAreReturned() async throws {
        var tinggRequest: TinggRequest = .shared
        tinggRequest.service = "FBA"
//        tinggRequest.billAccounts = billAccountUsecase()
        let dueBills = try await dueBillUsecase(tinggRequest: tinggRequest)
        let actual = dueBills.count
        let expected = 1
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
    
    func testConfirmDueBillReturnedIsNotGreaterThanFivedays() async throws {
        let dueBills = try await dueBillUsecase(tinggRequest: .init())
        let actualBill = dueBills[0]
        let actual = abs((makeDateFromString(validDateString: actualBill.dueDate) - Date()).day)
        let expected = 5
        XCTAssertTrue(actual <= expected)
    }
}
