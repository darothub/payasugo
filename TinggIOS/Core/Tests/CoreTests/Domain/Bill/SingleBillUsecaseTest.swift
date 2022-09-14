//
//  SingleBillUsecaseTest.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//
import Core
import XCTest

class SingleBillUsecaseTest: XCTestCase {
    var fetchBillRepository: FetchBillRepository!
    var singleDueBillUsecase: SingleDueBillUsecase!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fetchBillRepository = FetchBillRepositoryImpl(baseRequest: FakeBaseRequest(), dbObserver: Observer<Invoice>())
        singleDueBillUsecase = SingleDueBillUsecase(fetchBillRepository: fetchBillRepository)
    }
    
    func testASingleBillIsReturnetd() async throws {
        let result = try await singleDueBillUsecase(tinggRequest: .init())
        XCTAssertNotNil(result)
    }
}
