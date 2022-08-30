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
    @ObservedResults(Country.self) var observedDbCountries
    var countryRepository: CountryRepository?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        countryRepository = FakeCountryRepositoryImpl()
    }

    func testGetCountries() async throws {
        let countries = try await countryRepository?.getCountries()
        XCTAssertEqual(countries?.count, 1,
                       "Country was not properly updated from server.")
    }
    func testThatCountryNameIsCorrect() async {
        let countries = try? await countryRepository?.getCountries()
        XCTAssertEqual(observedDbCountries.first?.name, countries?.first?.name,
                       "Country was not properly updated from server.")
    }
    func testGetCountriesAndDialCode() async throws {
        let dict = try await countryRepository!.getCountriesAndDialCode()
        XCTAssertNotNil(dict)
    }
    func testCountriesDialCodeIsCorrect() async throws {
        let dict = try await countryRepository!.getCountriesAndDialCode()
        XCTAssertTrue(dict["BW"] == "267")
    }
    func testGetCountryByDialCode() {
        let country =  countryRepository?.getCountryByDialCode(dialCode: "267")
        XCTAssertEqual(country?.name, "Botswana")
    }
}
