//
//  EnrollmentRepositoryTest.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//

import XCTest
import Core

class EnrollmentRepositoryTest: XCTestCase {
    private var repository: EnrollmentRepository!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repository = FakeEnrollmentRepository(dbObserver: Observer<Enrollment>())
    }

    func testGetEnrollments() {
        let nominationInfo = repository.getNominationInfo()
        let actual = nominationInfo.count
        let expected = 3
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }

}
