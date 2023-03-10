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
        app/*@START_MENU_TOKEN@*/.buttons["getstarted"]/*[[".buttons[\"Get started\"]",".buttons[\"getstarted\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element/*@START_MENU_TOKEN@*/.children(matching: .staticText).matching(identifier: "countrycodeandflag").element(boundBy: 3)/*[[".children(matching: .staticText).matching(identifier: \"🇧🇼 +267\").element(boundBy: 3)",".children(matching: .staticText).matching(identifier: \"countrycodeandflag\").element(boundBy: 3)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let countryflag = app.staticTexts["countryflag"]
        let countryDialCode = app.staticTexts["countrydialcode"]
        XCTAssert(countryflag.waitForExistence(timeout: 5))
        XCTAssert(countryDialCode.waitForExistence(timeout: 5))
                
    }
    func testWhenACountryIsSelectedCountryAppearsInTheTextField(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let element = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element

        element/*@START_MENU_TOKEN@*/.children(matching: .staticText).matching(identifier: "countrycodeandflag").element(boundBy: 3)/*[[".children(matching: .staticText).matching(identifier: \"🇧🇼 +267\").element(boundBy: 3)",".children(matching: .staticText).matching(identifier: \"countrycodeandflag\").element(boundBy: 3)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let countryflag = app.staticTexts["countryflag"]
        XCTAssert(countryflag.waitForExistence(timeout: 5))
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Kenya"]/*[[".cells.staticTexts[\"Kenya\"]",".staticTexts[\"Kenya\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let selectionField = element.children(matching: .staticText).matching(identifier: "🇰🇪 +254").element(boundBy: 0)

        XCTAssert(selectionField.waitForExistence(timeout: 5))
    }
    func testWarningShowsUpWhenPolicyIsNotChecked(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
      
        let element = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element

        element/*@START_MENU_TOKEN@*/.children(matching: .staticText).matching(identifier: "countrycodeandflag").element(boundBy: 3)/*[[".children(matching: .staticText).matching(identifier: \"🇧🇼 +267\").element(boundBy: 3)",".children(matching: .staticText).matching(identifier: \"countrycodeandflag\").element(boundBy: 3)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Kenya"]/*[[".cells.staticTexts[\"Kenya\"]",".staticTexts[\"Kenya\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element/*@START_MENU_TOKEN@*/.children(matching: .textField).matching(identifier: "countrytextfield").element(boundBy: 3)/*[[".children(matching: .textField).matching(identifier: \"Phone Number\").element(boundBy: 3)",".children(matching: .textField).matching(identifier: \"countrytextfield\").element(boundBy: 3)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let key7 = app.keys["7"]
        key7.tap()
        let key = app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        key.tap()
        
        let key2 = app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()
        key2.tap()
        key2.tap()
        
        let key3 = app/*@START_MENU_TOKEN@*/.keys["8"]/*[[".keyboards.keys[\"8\"]",".keys[\"8\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key3.tap()
        
        let key4 = app/*@START_MENU_TOKEN@*/.keys["6"]/*[[".keyboards.keys[\"6\"]",".keys[\"6\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key4.tap()
        let key5 = app/*@START_MENU_TOKEN@*/.keys["7"]/*[[".keyboards.keys[\"7\"]",".keys[\"7\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key5.tap()
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element2/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "continuebtn").element(boundBy: 7)/*[[".children(matching: .button).matching(identifier: \"Continue\").element(boundBy: 7)",".children(matching: .button).matching(identifier: \"continuebtn\").element(boundBy: 7)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let warningAlert = app.alerts["Kindly accept terms and policy"].scrollViews.otherElements.buttons["alertbutton"]
        XCTAssert(warningAlert.waitForExistence(timeout: 5))
    }
    func testWarningShowsUpWhenUserTriesToSubmitAndEmptyPhoneNumber(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element2/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "continuebtn").element(boundBy: 7)/*[[".children(matching: .button).matching(identifier: \"Continue\").element(boundBy: 7)",".children(matching: .button).matching(identifier: \"continuebtn\").element(boundBy: 7)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let warningAlert = app.alerts["Phone number must not be empty"].scrollViews.otherElements.buttons["alertbutton"]
        XCTAssert(warningAlert.waitForExistence(timeout: 2))
                
    }
    func testUserInputCorrectPhoneNumberAndCheckedPolicyThenOTPViewShows(){
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
        let element = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element

        element/*@START_MENU_TOKEN@*/.children(matching: .staticText).matching(identifier: "countrycodeandflag").element(boundBy: 3)/*[[".children(matching: .staticText).matching(identifier: \"🇧🇼 +267\").element(boundBy: 3)",".children(matching: .staticText).matching(identifier: \"countrycodeandflag\").element(boundBy: 3)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Kenya"]/*[[".cells.staticTexts[\"Kenya\"]",".staticTexts[\"Kenya\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element/*@START_MENU_TOKEN@*/.children(matching: .textField).matching(identifier: "countrytextfield").element(boundBy: 3)/*[[".children(matching: .textField).matching(identifier: \"Phone Number\").element(boundBy: 3)",".children(matching: .textField).matching(identifier: \"countrytextfield\").element(boundBy: 3)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let key7 = app.keys["7"]
        key7.tap()
        let key = app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        key.tap()
        
        let key2 = app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()
        key2.tap()
        key2.tap()
        
        let key3 = app/*@START_MENU_TOKEN@*/.keys["8"]/*[[".keyboards.keys[\"8\"]",".keys[\"8\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key3.tap()
        
        let key4 = app/*@START_MENU_TOKEN@*/.keys["6"]/*[[".keyboards.keys[\"6\"]",".keys[\"6\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key4.tap()
        let key5 = app/*@START_MENU_TOKEN@*/.keys["7"]/*[[".keyboards.keys[\"7\"]",".keys[\"7\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key5.tap()
        
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element2/*@START_MENU_TOKEN@*/.children(matching: .image).matching(identifier: "policycheckbox").element(boundBy: 3)/*[[".children(matching: .image).matching(identifier: \"Square\").element(boundBy: 3)",".children(matching: .image).matching(identifier: \"policycheckbox\").element(boundBy: 3)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element2/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "continuebtn").element(boundBy: 7)/*[[".children(matching: .button).matching(identifier: \"Continue\").element(boundBy: 7)",".children(matching: .button).matching(identifier: \"continuebtn\").element(boundBy: 7)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let OTPHeadingtext = app.staticTexts["Confirm OTP"]
        XCTAssert(OTPHeadingtext.waitForExistence(timeout: 5))
                
    }
}

