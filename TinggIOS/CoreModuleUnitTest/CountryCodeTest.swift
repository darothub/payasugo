//
//  Country.swift
//  
//
//  Created by Abdulrasaq on 02/08/2022.
//
// swiftlint:disable all
import XCTest
import Core

class CountryCodeTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCountryCode_BW_ShouldReturn_Botswana(){
        let actual = getCountryName(countryCode: "BW")
        let expected = "Botswana"
        XCTAssertEqual(actual, expected)
    }
    func testCountryCode_NG_ShouldReturn_Nigeria(){
        let actual = getCountryName(countryCode: "NG")
        let expected = "Nigeria"
        XCTAssertEqual(actual, expected)
    }
    func testCountryCodeKE_ShouldReturn_Kenya(){
        let actual = getCountryName(countryCode: "KE")
        let expected = "Kenya"
        XCTAssertEqual(actual, expected)
    }
    func testCountryCode_GH_ShouldReturn_Ghana(){
        let actual = getCountryName(countryCode: "GH")
        let expected = "Ghana"
        XCTAssertEqual(actual, expected)
    }

}
