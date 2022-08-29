//
//  PhoneTextFieldUnitTest.swift
//  
//
//  Created by Abdulrasaq on 25/08/2022.
//
import Common
import XCTest
class PhoneTextFieldUnitTest: XCTestCase {

    func testCountryCodeBWShouldReturnBotswana(){
        let actual = getCountryName(countryCode: "BW")
        let expected = "Botswana"
        XCTAssertEqual(actual, expected)
    }
    func testCountryCodeNGShouldReturnNigeria(){
        let actual = getCountryName(countryCode: "NG")
        let expected = "Nigeria"
        XCTAssertEqual(actual, expected)
    }
    func testCountryCodeKEShouldReturnKenya(){
        let actual = getCountryName(countryCode: "KE")
        let expected = "Kenya"
        XCTAssertEqual(actual, expected)
    }
    func testCountryCodeGHShouldReturnGhana(){
        let actual = getCountryName(countryCode: "GH")
        let expected = "Ghana"
        XCTAssertEqual(actual, expected)
    }

}
