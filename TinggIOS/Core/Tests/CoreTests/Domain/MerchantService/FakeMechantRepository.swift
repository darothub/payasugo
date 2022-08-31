//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//
import Core
import Foundation
import RealmSwift
class FakeMerchantRepository: MerchantServiceRepository {
    var services = Observer<MerchantService>().objects
    private var data = "{\"SERVICE_NAME\": \"DStv\",\"CLIENT_NAME\": \"Multichoice Kenya\",\"HUB_CLIENT_ID\": \"3\",\"SERVICE_CODE\": \"DSTVKE\",\"HUB_SERVICE_ID\": \"1\",\"CLIENT_CODE\": \"MULTICKE\",\"MIN_AMOUNT\": \"10.00\",\"MAX_AMOUNT\": \"100000.00\",\"SERVICE_PATTERN_ID\": \"3\",\"SERVICE_ACCOUNT_KEY\": \"1\",\"EXACT_PAYMENT\": \"yes\",\"CATEGORY_ID\": \"1\",\"ACTIVE_STATUS\": \"1\",\"SERVICE_LOGO\": \"https://mula.co.ke/mula_ke/api/v1/images/services/dstv.png\",\"IS_PREPAID_SERVICE\": \"0\",\"PAYBILL\": \"811926\",\"NETWORK_ID\": \"63021\",\"WEB_TEMPLATE_ID\": \"2\",\"RECEIVER_SOURCE_ADDRESS\": \"multichoice\",\"REFERENCE_LABEL\": \"Smart Card Number\",\"PRESENTMENT_TYPE\": \"hasPresentment\",\"REFERENCE_INPUT_MASK\": \"(^[0-9]{8}$)|(^[0-9]{10}$)|(^[0-9]{11}$)\",\"FORMAT_ERROR_MESSAGE\": \"Please use a Valid Smart Card Number found on the card inserted in your decoder.\",\"INPUT_TYPE\": \"numeric\",\"COLOR_CODE\": \"#2981D1\",\"FORM_TYPE\": \"STATIC_FORM\",\"FORM_PARAMETERS\": \"\",\"ABBREVIATION\": \"DS\",\"PAYMENT_LABEL\": \"Pay\",\"ORDER_ID\": \"2\",\"REGEX_TYPE\": \"0\",\"IS_BUNDLE_SERVICE\": \"0\",\"IGNORE_SAVE_ENROLLMENT\": \"0\",\"HAS_BILL_AMOUNT\": \"1\",\"SERVICE_PARAMETERS\": \"\",\"BUNDLE_LABEL\": \"\",\"BUNDLE_CATEGORY_LABEL\": \"\",\"DISPLAY_NO_PENDING_BILL_DIALOG\": \"0\",\"CAN_EDIT_AMOUNT\": \"1\",\"IS_CYCLIC_SERVICE\": \"1\",\"IS_DISLAYABLE_ON_LIFESTREAM\": \"1\",\"FAVORITES_DISPLAY_MODE\": \"SHOW_ALL\",\"IS_REFRESH\": \"NO\",\"APPLICABLE_CHARGES\": [],\"VALIDATE_BILL_AMOUNT\": \"NO\",\"CHARGES\": \"\",\"TITLE\": \"Inactive Service!\",\"MESSAGE\": \"DSTV is currently unavailable. We apologize for any inconvenience cause\"}".data(using: .utf8)!
    
    public init() {
        //Public init
      
    }
    func saveDataInDB() {
        do {
            let realm = try Realm()
            try realm.write {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                realm.create(MerchantService.self, value: json)
            }
        } catch {
            print("Test Error\(error)")
        }
    }
    
    func getServices() -> [MerchantService] {
       [
        MerchantService(),
        MerchantService(),
        MerchantService(),
        MerchantService(),
        MerchantService(),
        MerchantService(),
        MerchantService(),
        MerchantService(),
        MerchantService(),
        
       ]
    }
}
