//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/09/2022.
//

import Foundation
import XCTest
import Core
import RealmSwift
class GetCountriesAndDialCodeUseCaseTest: XCTestCase {
    var countryRepository: CountryRepository!
    var getCountriesAndDialCodeUseCase: GetCountriesAndDialCodeUseCase!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        countryRepository = FakeCountryRepositoryImpl(dbObserver: Observer<Country>())
        getCountriesAndDialCodeUseCase = GetCountriesAndDialCodeUseCase(countryRepository: countryRepository)
    }
    
    func testThatADictionaryOfCountriesAndDialCodeIsReturned() async throws  {
        let actual = try await getCountriesAndDialCodeUseCase()
        XCTAssertTrue(actual is [String: String])
    }
    
    func testThatCountryCodeAndDialCodeAreCorrect() async throws  {
        let actual = try await getCountriesAndDialCodeUseCase()
        let expected = ["BW": "267"]
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(actual)")
    }
}
