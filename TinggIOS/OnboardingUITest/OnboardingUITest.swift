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
    
        let mobileNumberText = app.staticTexts["mobilenumber"]
        tapGetStartedButton()
        XCTAssert(mobileNumberText.waitForExistence(timeout: 5))
    }
    func testWhenOnPhoneVerificationATextFieldExist(){
        tapGetStartedButton()
        let countrytextfield = app.textFields["countrytextfield"]
        XCTAssert(countrytextfield.waitForExistence(timeout: 5))
        
    }
    
    func testWhenOnPhoneVerificationScreenCountryAndCodeFieldExist(){
        tapGetStartedButton()
        let countrycodeandflag = app.staticTexts["countrycodeandflag"]
        XCTAssert(countrycodeandflag.waitForExistence(timeout: 5))
    }
    func testOnPhoneVerificationScreenWhenCountryFlagIsClickedASheetShowsUp(){
        
        tapGetStartedButton()
        app/*@START_MENU_TOKEN@*/.staticTexts["countrycodeandflag"]/*[[".staticTexts[\"🇧🇼 +267\"]",".staticTexts[\"countrycodeandflag\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let countryflag = app.staticTexts["countryflag"]
        let countryDialCode = app.staticTexts["countrydialcode"]
        XCTAssert(countryflag.waitForExistence(timeout: 5))
        XCTAssert(countryDialCode.waitForExistence(timeout: 5))
                
    }
    func testWhenACountryIsSelectedCountryAppearsInTheTextField(){
        tapGetStartedButton()
        tapGetStartedButtonThenPickACountry()
        let textField = app.staticTexts["🇰🇪 +254"]

        XCTAssert(textField.waitForExistence(timeout: 5))
    }
    func testContinueButtonIsDisabledWhenPolicyIsNotChecked(){
        tapGetStartedButton()
        tapGetStartedButtonThenPickACountry()
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
        let continueBtn = app/*@START_MENU_TOKEN@*/.buttons["continuebtn"]/*[[".buttons[\"Continue\"]",".buttons[\"continuebtn\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        continueBtn.tap()
        XCTAssert(!continueBtn.isEnabled)
    }
    func testContinueButtonIsDisabledWhenWhenUserTriesToSubmitAndEmptyPhoneNumber(){
        tapGetStartedButton()
        let continueBtn = app/*@START_MENU_TOKEN@*/.buttons["continuebtn"]/*[[".buttons[\"Continue\"]",".buttons[\"continuebtn\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        continueBtn.tap()
        XCTAssert(!continueBtn.isEnabled)
                
    }
    func testUserInputCorrectPhoneNumberAndCheckedPolicyThenOTPViewShows(){
        tapGetStartedButton()
        tapGetStartedButtonThenPickACountry()
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
        app/*@START_MENU_TOKEN@*/.images["policycheckbox"]/*[[".images[\"Square\"]",".images[\"policycheckbox\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let continueBtn = app/*@START_MENU_TOKEN@*/.buttons["continuebtn"]/*[[".buttons[\"Continue\"]",".buttons[\"continuebtn\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        continueBtn.tap()
        app.staticTexts["Confirm OTP"]
        let OTPHeadingtext = app.staticTexts["Confirm OTP"]
        XCTAssert(OTPHeadingtext.waitForExistence(timeout: 5))
                
    }
    
    func tapGetStartedButton() {
        let button = app.buttons["getstarted"]
        XCTAssert(button.waitForExistence(timeout: 5))
        button.tap()
    }
    func tapGetStartedButtonThenPickACountry() {
        app/*@START_MENU_TOKEN@*/.staticTexts["countrycodeandflag"]/*[[".staticTexts[\"🇧🇼 +267\"]",".staticTexts[\"countrycodeandflag\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Kenya"]/*[[".cells.staticTexts[\"Kenya\"]",".staticTexts[\"Kenya\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.textFields["countrytextfield"]/*[[".textFields[\"Phone Number\"]",".textFields[\"countrytextfield\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}

