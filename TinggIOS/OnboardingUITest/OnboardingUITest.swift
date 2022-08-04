//
//  OnboardingUITest.swift
//  OnboardingUITest
//
//  Created by Abdulrasaq on 02/08/2022.
//
// swiftlint:disable all
import XCTest

class OnboardingUITest: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testToShowTinggLogoOnSplashScreen() {
        let splashScreenLogo = app.images["tinggsplashscreenlogo"]
        XCTAssert(splashScreenLogo.waitForExistence(timeout: 1))
    }
    func testThatAddBillTextShowsOnOnboardingScreen() {
        let onboardingAddBillText = app.staticTexts["addyourbillontingg"]
        XCTAssert(onboardingAddBillText.waitForExistence(timeout: 5))
    }
    func testThatTinggGreenLogoShowsOnOnboardingScreen() {
        let tingggreenlogo = app.images["tingggreenlogo"]
        XCTAssert(tingggreenlogo.waitForExistence(timeout: 5))
    }
    func testWhenGetStartedButtonIsClickedItNavigatesToPhoneVerificationScreen() {
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let mobileNumberText = app.staticTexts["mobilenumber"]
        XCTAssert(mobileNumberText.waitForExistence(timeout: 5))
    }
    func testWhenOnPhoneVerificationATextFieldExist(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let countrytextfield = app.textFields["countrytextfield"]
        XCTAssert(countrytextfield.waitForExistence(timeout: 5))
    }
    
    func testWhenOnPhoneVerificationScreenCountryAndCodeFieldExist(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let countrycodeandflag = app.staticTexts["countrycodeandflag"]
        XCTAssert(countrycodeandflag.waitForExistence(timeout: 5))
    }
    func testOnPhoneVerificationScreenWhenCountryFlagIsClickedASheetShowsUp(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let countrycodeandflag = app.staticTexts["countrycodeandflag"]
        XCTAssert(countrycodeandflag.waitForExistence(timeout: 5))
        countrycodeandflag.tap()
        let countryflag = app.staticTexts["countryflag"]
        XCTAssert(countryflag.waitForExistence(timeout: 5))
        
                
                
    }
}
//        let tabView = app.collectionViews["onboardingtabview"]
//        tabView/*@START_MENU_TOKEN@*/.cells/*[[".scrollViews.cells",".cells"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other)
//            .element.children(matching: .other).element.swipeRight()
//        XCTAssert(button.waitForExistence(timeout: 5))
//        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Back"].tap()
