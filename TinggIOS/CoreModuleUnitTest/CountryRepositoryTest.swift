//
//  CountryRepositoryTest.swift
//  
//
//  Created by Abdulrasaq on 09/08/2022.
//
//swiftlint:disable all
import XCTest
import Core
import RealmSwift
class CountryRepositoryTest: XCTestCase {
    @ObservedResults(Country.self) var observedDbCountries
    var countryRepository: CountryRepository?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        countryRepository = CountryRepoistoryTestImpl()
    }

    func testGetCountriesCountIsOne() async throws {
        let countries = try await countryRepository?.getCountries()
        XCTAssertEqual(countries?.count, 1,
                       "Country was not properly updated from server.")
    }
    
    func testThatCountryNameIsCorrect() async {
        let countries = try? await countryRepository?.getCountries()
        XCTAssertEqual(observedDbCountries.first?.name, countries?.first?.name,
                       "Country was not properly updated from server.")
    }

}

