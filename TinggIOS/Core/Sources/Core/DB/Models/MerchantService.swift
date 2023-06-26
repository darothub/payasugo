//
//  MerchantService.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift

// MARK: - MerchantService

public class MerchantService: Object, DBObject, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var serviceName: String = "Unknown"
    @Persisted public var clientName: String = ""
    @Persisted public var hubClientID: String = ""
    @Persisted public var serviceCode: String = ""
    @Persisted public var hubServiceID: String = ""
    @Persisted public var clientCode:String = ""
    @Persisted public var minAmount:String = ""
    @Persisted public var maxAmount: String = ""
    @Persisted public var servicePatternID:String = ""
    @Persisted public var serviceAccountKey:String = ""
    @Persisted public var exactPayment:String = ""
    @Persisted public var categoryID: String = ""
    @Persisted public var activeStatus: String = ""
    @Persisted public var serviceLogo: String = ""
    @Persisted public var isPrepaidService:String = ""
    @Persisted public var paybill:String = ""
    @Persisted public var networkID:String = ""
    @Persisted public var webTemplateID: String = ""
    @Persisted public var receiverSourceAddress:String = ""
    @Persisted public var referenceLabel:String = ""
    @Persisted public var presentmentType:String = ""
    @Persisted public var referenceInputMask: String = ""
    @Persisted public var formatErrorMessage:String = ""
    @Persisted public var inputType:String = ""
    @Persisted public var colorCode:String = ""
    @Persisted public var formType: String = ""
    @Persisted public var formParameters: FORMPARAMETERSClassEntity?
    @Persisted public var abbreviation:String = ""
    @Persisted public var paymentLabel:String = ""
    @Persisted public var orderID: String = ""
    @Persisted public var regexType:String = ""
    @Persisted public var isBundleService:String = ""
    @Persisted public var ignoreSaveEnrollment:String = ""
    @Persisted public var hasBillAmount: String = ""
    @Persisted public var serviceParameters: ServiceParametersEntity?
    @Persisted public var bundleLabel:String = ""
    @Persisted public var bundleCategoryLabel:String = ""
    @Persisted public var displayNoPendingBillDialog: String = ""
    @Persisted public var canEditAmount:String = ""
    @Persisted public var isCyclicService:String = ""
    @Persisted public var isDislayableOnLifestream:String = ""
    @Persisted public var favoritesDisplayMode: String = ""
    @Persisted public var isRefresh: String = ""
    @Persisted public var applicableCharges = List<String>()
    @Persisted public var validateBillAmount: String = ""
    @Persisted public var charges: String = ""
    @Persisted public var title: String = ""
    @Persisted public var message: String = ""
    public static var MULA_CHAMA_ID = "187"
    enum CodingKeys: String, CodingKey {
        case serviceName = "SERVICE_NAME"
        case clientName = "CLIENT_NAME"
        case hubClientID = "HUB_CLIENT_ID"
        case serviceCode = "SERVICE_CODE"
        case hubServiceID = "HUB_SERVICE_ID"
        case clientCode = "CLIENT_CODE"
        case minAmount = "MIN_AMOUNT"
        case maxAmount = "MAX_AMOUNT"
        case servicePatternID = "SERVICE_PATTERN_ID"
        case serviceAccountKey = "SERVICE_ACCOUNT_KEY"
        case exactPayment = "EXACT_PAYMENT"
        case categoryID = "CATEGORY_ID"
        case activeStatus = "ACTIVE_STATUS"
        case serviceLogo = "SERVICE_LOGO"
        case isPrepaidService = "IS_PREPAID_SERVICE"
        case paybill = "PAYBILL"
        case networkID = "NETWORK_ID"
        case webTemplateID = "WEB_TEMPLATE_ID"
        case receiverSourceAddress = "RECEIVER_SOURCE_ADDRESS"
        case referenceLabel = "REFERENCE_LABEL"
        case presentmentType = "PRESENTMENT_TYPE"
        case referenceInputMask = "REFERENCE_INPUT_MASK"
        case formatErrorMessage = "FORMAT_ERROR_MESSAGE"
        case inputType = "INPUT_TYPE"
        case colorCode = "COLOR_CODE"
        case formType = "FORM_TYPE"
        case formParameters = "FORM_PARAMETERS"
        case abbreviation = "ABBREVIATION"
        case paymentLabel = "PAYMENT_LABEL"
        case orderID = "ORDER_ID"
        case regexType = "REGEX_TYPE"
        case isBundleService = "IS_BUNDLE_SERVICE"
        case ignoreSaveEnrollment = "IGNORE_SAVE_ENROLLMENT"
        case hasBillAmount = "HAS_BILL_AMOUNT"
        case serviceParameters = "SERVICE_PARAMETERS"
        case bundleLabel = "BUNDLE_LABEL"
        case bundleCategoryLabel = "BUNDLE_CATEGORY_LABEL"
        case displayNoPendingBillDialog = "DISPLAY_NO_PENDING_BILL_DIALOG"
        case canEditAmount = "CAN_EDIT_AMOUNT"
        case isCyclicService = "IS_CYCLIC_SERVICE"
        case isDislayableOnLifestream = "IS_DISLAYABLE_ON_LIFESTREAM"
        case favoritesDisplayMode = "FAVORITES_DISPLAY_MODE"
        case isRefresh = "IS_REFRESH"
        case applicableCharges = "APPLICABLE_CHARGES"
        case validateBillAmount = "VALIDATE_BILL_AMOUNT"
        case charges = "CHARGES"
        case title = "TITLE"
        case message = "MESSAGE"
    }
    public var isAirtimeService: Bool {
        return self.categoryID == "2"
    }
    public var isABundleService: Bool {
        return self.isBundleService == "1"
    }
    public var hasPayerCharge: Bool {
        return applicableCharges.contains("PAYER_CHARGE")
    }
    public var hasTierCharge: Bool {
        return applicableCharges.contains("TIER_CHARGE")
    }
    
}

// MARK: - SERVICEPARAMETERS
public class ServiceParametersEntity: Object, ObjectKeyIdentifiable, Codable {
    @Persisted public var servicesData = List<ServicesDatumEntity>()
    
    enum CodingKeys: String, CodingKey {
        case servicesData = "SERVICES_DATA"
    }
}

//MARK: - ServicesDatumEntity
public class ServicesDatumEntity: Object, ObjectKeyIdentifiable, Codable {
    @Persisted public var serviceID: Int
    @Persisted public var serviceName: String
    
    enum CodingKeys: String, CodingKey {
        case serviceID = "SERVICE_ID"
        case serviceName = "SERVICE_NAME"
    }
}

public var sampleServices:[MerchantService]  {
    let service1 = MerchantService()
    service1.serviceLogo = "https://cdn3.vectorstock.com/i/1000x1000/35/52/placeholder-rgb-color-icon-vector-32173552.jpg"
    service1.serviceName = "Service one"
    let service2 = MerchantService()
    service2.serviceLogo = "https://cdn3.vectorstock.com/i/1000x1000/35/52/placeholder-rgb-color-icon-vector-32173552.jpg"
    service2.serviceName = "Service two"
    return [service1, service2]
}


// MARK: - FORMPARAMETERSClass
public class FORMPARAMETERSClassEntity: Object, DBObject, ObjectKeyIdentifiable, Codable {
    @Persisted public var formParameters = List<FormParameterEntity>()
    @Persisted public var name: String?
    @Persisted public var label: String?

    enum CodingKeys: String, CodingKey {
        case formParameters = "FORM_PARAMETERS"
        case name = "NAME"
        case label = "LABEL"
    }
}

// MARK: - FormParameter
public class FormParameterEntity: Object, DBObject, ObjectKeyIdentifiable, Codable {
    @Persisted public var itemName: String?
    @Persisted public var displayName: String?
    @Persisted public var itemType : String?
    @Persisted public var isReferenceField: String?
    @Persisted public var keyValueData: String?
    @Persisted public var name: String?
    @Persisted public var items = List<ItemEntity>()

    enum CodingKeys: String, CodingKey {
        case itemName = "ITEM_NAME"
        case displayName = "DISPLAY_NAME"
        case itemType = "ITEM_TYPE"
        case isReferenceField = "IS_REFERENCE_FIELD"
        case keyValueData = "KEY_VALUE_DATA"
        case name = "NAME"
        case items = "ITEMS"
    }
}

public class ItemEntity: Object, DBObject, ObjectKeyIdentifiable, Codable {
    @Persisted public var itemID: Int
    @Persisted public var name: String
    @Persisted public var amount: Int

    enum CodingKeys: String, CodingKey {
        case itemID = "ITEM_ID"
        case name = "NAME"
        case amount = "AMOUNT"
    }
}
