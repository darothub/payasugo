//
//  File.swift
//  
//
//  Created by Abdulrasaq on 25/08/2022.
//

import Core
import Foundation
import XCTest
class GetCountriesUsecaseTest: XCTestCase {
    var getCountriesUsecase: GetCountriesUsecase?
    var countryRepository: CountryRepository?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        countryRepository = FakeCountryRepositoryImpl()
        getCountriesUsecase = GetCountriesUsecaseImpl(countryRepository: countryRepository!)
    }

    func testGetCountriesAndDialCode() async throws {
        let dict = try await getCountriesUsecase?.callAsFunction()
        XCTAssertNotNil(dict)
    }
    func testGetCountriesByDialCode()  {
        let country = getCountriesUsecase?.callAsFunction(dialCode: "267")
        XCTAssertEqual(country?.name, "Botswana")
    }
    
    func testGetCountriesByDialCodeReturnFalseWhenInCorrect()  {
        let country = getCountriesUsecase?.callAsFunction(dialCode: "267")
        XCTAssertFalse(country?.name ==  "Botswanas")
    }
 
}
