//
//  DatabaseTest.swift
//  
//
//  Created by Abdulrasaq on 09/08/2022.
//

import XCTest
import Core
import RealmSwift
//swiftlint:disable all
class DatabaseTest: XCTestCase {
    override func setUpWithError() throws {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testThatObjectIsCreatedFromApiResponse() {
        let json = "{\"name\":\"Botswana\",\"COUNTRY_ID\":\"30\",\"COUNTRY_CODE\":\"BW\",\"COUNTRY_URL\":\"https://kartana.tingg.africa/pci/mula_bw/api/v1/\",\"COUNTRY_DIAL_CODE\":\"267\",\"MULA_CLIENT_ID\":\"113\",\"STATUS\":\"1\",\"ALLOW_DECIMALS\":true,\"CURRENCY\":\"BWP\",\"CURRENCY_ID\":\"23\",\"CURRENCY_NAME\":\"Pula\",\"COUNTRY_URL_NEW\":\"https://kartana.tingg.africa/pci/mula_bw/api/v1/\",\"HOTLINE_APP_KEY\":\"5571ab80-4d1c-4516-b223-95831d14d1ac\",\"HOTLINE_APP_ID\":\"6a1b271f-1616-4d70-abac-dcee34482ee1\",\"FAQ_URL\":\"https://mula.co.ke/faq.html\",\"TAC_URL\":\"https://mula.co.ke/terms-of-service.php\",\"PRIVACY_POLICY_URL\":\"https://mula.co.ke/privacy-policy.php\",\"EXCLUDED_SMS_SOURCE_ADDRESSES\":[],\"COUNTRY_MOBILE_REGEX\":\"^[+]|[0-9]{8,11}$\",\"GENERIC_ACCOUNT_NUMBER_REGEX\":\"\",\"EXTRACT_SMS_ON_PROFILING\":\"\",\"COUNTRY_CURRENCY_REGEX\":\"\",\"COUNTRY_SOURCE_ADDRESSES\":\"\",\"CONFIRMED_ACCOUNT_LIMITS\":\"\",\"ALPHANUMERIC_REGEXES\":\"\",\"FRESHCHAT_APP_KEY\":\"9b82f192-a2b9-4925-a466-a998b8fd43e1\",\"FRESHCHAT_APP_ID\":\"3ada471d-9ae3-413f-943a-bd4d3f2ff197\",\"ROUND_UP_AMOUNTS\":\"NO\",\"COUNTRY_FLAG\":\"https://mula.co.ke/mula_ke/api/v1/images/flags/Botswana.png\",\"MAXIMUM_CARDS\":\"3\",\"CLEVERTAP_ACCOUNT_ID\":\"W84-RK9-645Z\",\"CLEVERTAP_TOKEN\":\"c32-4b0\",\"HAS_WALLET\":0,\"HAS_GROUPS\":0,\"HAS_FLOATING_BUTTON\":0,\"HAS_DISCOVER\":0,\"USE_SMILE_SDK\":0,\"HAS_REFERRAL\":0,\"FETCH_BEARER_TOKEN_URL\":\"https://tinggauthapi.cellulant.co.ke/tingg/api/fetchToken/\"}".data(using: .utf8)!

        do {
            let realm = try Realm()
            try realm.write {
                let json = try JSONSerialization.jsonObject(with: json, options: [])
                realm.create(Country.self, value: json)
            }
            XCTAssertEqual(realm.objects(Country.self).first?.name, "Botswana",
                           "Country was not properly updated from server.")
        } catch {
            print("Realm writing error")
        }
    
    }
}


