//
//  ProfileRepositoryTest.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//

import Core
import RealmSwift
import XCTest

class ProfileRepositoryTest: XCTestCase {
    private var repository: FakeProfileRepository!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repository = FakeProfileRepository(dbObserver: Observer<Profile>())
    }

    func testGetProfile() {
        let profile = repository.getProfile()!
        let actual = profile.profileID
        let expected = FakeProfileRepository.profileId
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
}
