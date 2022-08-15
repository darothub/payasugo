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
        countrycodeandflag.tap()
        let countryflag = app.staticTexts["countryflag"]
        XCTAssert(countryflag.waitForExistence(timeout: 5))
                
    }
    func testWarningShowsUpWhenPolicyIsNotChecked(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let countrytextfield = app.textFields["Phone Number"]
        countrytextfield.tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        let continueButton = app.buttons["Continue"]
        XCTAssert(continueButton.waitForExistence(timeout: 5))
        continueButton.tap()
        let warningText = app.staticTexts["You must accept terms of use and privacy policy to proceed!"]
        XCTAssert(warningText.waitForExistence(timeout: 5))
        let warningButton = app.buttons["OK"]
        XCTAssert(warningButton.waitForExistence(timeout: 5))
                
    }
    func testWarningShowsUpWhenUserTriesToSubmitAndEmptyPhoneNumber(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let continueButton = app.buttons["Continue"]
        continueButton.tap()
        let warningText = app.staticTexts["Phone number can not be empty"]
        XCTAssert(warningText.waitForExistence(timeout: 5))
        let warningButton = app.buttons["OK"]
        XCTAssert(warningButton.waitForExistence(timeout: 5))
                
    }
    func testUserInputCorrectPhoneNumberAndCheckedPolicyThenOTPViewShows(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let countrytextfield = app.textFields["Phone Number"]
        XCTAssert(countrytextfield.waitForExistence(timeout: 3))
        countrytextfield.tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app/*@START_MENU_TOKEN@*/.images["policycheckbox"]/*[[".images[\"Square\"]",".images[\"policycheckbox\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Continue"].tap()
        let OTVHeadingtext = app.staticTexts["Confirm OTP"]
        XCTAssert(OTVHeadingtext.waitForExistence(timeout: 5))
                
    }
}

