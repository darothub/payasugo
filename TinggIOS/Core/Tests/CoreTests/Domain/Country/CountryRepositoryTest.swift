//
//  File.swift
//  
//
//  Created by Abdulrasaq on 25/08/2022.
//
import Core
import Foundation
import RealmSwift
import XCTest
class CountryRepositoryTest: XCTestCase {
    
    var countryRepository: CountryRepository?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        countryRepository = FakeCountryRepositoryImpl(dbObserver: Observer<CountriesInfoDTO>())
    }

    func testGetCountries() async throws {
        let actual = try await countryRepository?.getCountries().count
        let expected = 1
        XCTAssertEqual(actual, expected,
                       "Expected \(expected) but found \(actual)")
    }
    func testThatCountryNameIsCorrect() async {
        let actual = try? await countryRepository?.getCountries().first?.name
        let expected = "Botswana"
        XCTAssertEqual(actual, expected,
                       "Expected \(expected) but found \(actual)")
    }
}
