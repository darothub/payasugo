//
//  BaseRequestTest.swift
//  
//
//  Created by Abdulrasaq on 02/09/2022.
//

import XCTest
import Core

class BaseRequestTest: XCTestCase {
    var baseRequest: FakeBaseRequest!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        baseRequest = FakeBaseRequest()
    }
    
    func testCallIncreasesWhenMakeRequestIsCalled() {
        let request = baseRequest.makeRequest(tinggRequest: .init()) {(result: Result<FetchBillDTO, ApiError>) in
            
        }
        let actual = baseRequest.call
        let expected = 1
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }

}
