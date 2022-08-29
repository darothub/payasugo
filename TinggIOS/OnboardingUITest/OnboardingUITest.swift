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
        let element = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element/*@START_MENU_TOKEN@*/.children(matching: .staticText).matching(identifier: "countrycodeandflag").element(boundBy: 0)/*[[".children(matching: .staticText).matching(identifier: \"🇧🇼 +267\").element(boundBy: 0)",".children(matching: .staticText).matching(identifier: \"countrycodeandflag\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let countryflag = app.staticTexts["countryflag"]
        let countryDialCode = app.staticTexts["countrydialcode"]
        XCTAssert(countryflag.waitForExistence(timeout: 5))
        XCTAssert(countryDialCode.waitForExistence(timeout: 5))
                
    }
    func testWhenACountryIsSelectedCountryAppearsInTheTextField(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let element = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element/*@START_MENU_TOKEN@*/.children(matching: .staticText).matching(identifier: "countrycodeandflag").element(boundBy: 0)/*[[".children(matching: .staticText).matching(identifier: \"🇧🇼 +267\").element(boundBy: 0)",".children(matching: .staticText).matching(identifier: \"countrycodeandflag\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let countryflag = app.staticTexts["countryflag"]
        XCTAssert(countryflag.waitForExistence(timeout: 5))
        let element2 = app.tables.cells["🇰🇪, Kenya, +254"].children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element2.tap()
        let selectionField = element.children(matching: .staticText).matching(identifier: "🇰🇪 +254").element(boundBy: 0)

        XCTAssert(selectionField.waitForExistence(timeout: 5))
    }
    func testWarningShowsUpWhenPolicyIsNotChecked(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
      
        let countrytextfield =  app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element/*@START_MENU_TOKEN@*/.children(matching: .textField).matching(identifier: "countrytextfield").element(boundBy: 0)/*[[".children(matching: .textField).matching(identifier: \"Phone Number\").element(boundBy: 0)",".children(matching: .textField).matching(identifier: \"countrytextfield\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        countrytextfield.tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        let continueBtn = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "continuebtn").element(boundBy: 0)/*[[".children(matching: .button).matching(identifier: \"Continue\").element(boundBy: 0)",".children(matching: .button).matching(identifier: \"continuebtn\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(continueBtn.waitForExistence(timeout: 2))
        continueBtn.tap()
        let warningAlert = app.alerts["You must accept terms of use and privacy policy to proceed!"].scrollViews.otherElements/*@START_MENU_TOKEN@*/.buttons["warningbutton"]/*[[".buttons[\"OK\"]",".buttons[\"warningbutton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(warningAlert.waitForExistence(timeout: 5))
    }
    func testWarningShowsUpWhenUserTriesToSubmitAndEmptyPhoneNumber(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let continueBtn = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "continuebtn").element(boundBy: 0)/*[[".children(matching: .button).matching(identifier: \"Continue\").element(boundBy: 0)",".children(matching: .button).matching(identifier: \"continuebtn\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(continueBtn.waitForExistence(timeout: 2))
        continueBtn.tap()
        let warningAlert = app.alerts["Phone number can not be empty"].scrollViews.otherElements/*@START_MENU_TOKEN@*/.buttons["warningbutton"]/*[[".buttons[\"OK\"]",".buttons[\"warningbutton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(warningAlert.waitForExistence(timeout: 2))
                
    }
    func testUserInputCorrectPhoneNumberAndCheckedPolicyThenOTPViewShows(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let countrytextfield =  app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).matching(identifier: "countrytextfield").element(boundBy: 0)
        XCTAssert(countrytextfield.waitForExistence(timeout: 1))
        countrytextfield.tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.keys["7"].tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element/*@START_MENU_TOKEN@*/.children(matching: .image).matching(identifier: "policycheckbox").element(boundBy: 0)/*[[".children(matching: .image).matching(identifier: \"Square\").element(boundBy: 0)",".children(matching: .image).matching(identifier: \"policycheckbox\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let continueBtn = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "continuebtn").element(boundBy: 0)/*[[".children(matching: .button).matching(identifier: \"Continue\").element(boundBy: 0)",".children(matching: .button).matching(identifier: \"continuebtn\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(continueBtn.waitForExistence(timeout: 2))
        continueBtn.tap()
        let OTPHeadingtext = app.staticTexts["Confirm OTP"]
        XCTAssert(OTPHeadingtext.waitForExistence(timeout: 5))
                
    }
}

