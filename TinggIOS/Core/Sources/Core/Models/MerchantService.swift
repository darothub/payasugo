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
//    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted(primaryKey: true) public var clientName: String? = ""
    @Persisted public var showAll: String? = ""
    @Persisted public var serviceName: String? = ""
    @Persisted public var serviceCode: String? = ""
    @Persisted public var activeStatus: String? = ""
    @Persisted public var serviceLogo: String? = ""
    @Persisted public var receiverSourceAddress: String? = ""
    @Persisted public var hubServiceID: String? = ""
    @Persisted public var hubClientID: String? = ""
    @Persisted public var minAmount: String? = ""
    @Persisted public var abbreviation: String? = ""
    @Persisted public var clientCode: String? = ""
    @Persisted public var maxAmount: String? = ""
    @Persisted public var referenceInputMask: String? = ""
    @Persisted public var formatErrorMessage: String? = ""
    @Persisted public var servicePatternID: String? = ""
    @Persisted public var isPrepaidService: String? = ""
    @Persisted public var paybill: String? = ""
    @Persisted public var networkID: String? = ""
    @Persisted public var webTemplateID: String? = ""
    @Persisted public var colorCode: String? = ""
    @Persisted public var orderID: String? = ""
    @Persisted public var serviceImage: String? = ""
    @Persisted public var presentmentType: String? = ""
    @Persisted public var referenceLabel: String? = ""
    @Persisted public var inputType: String? = ""
    @Persisted public var formType: String? = ""
//    @Persisted public var formParameters: String? = ""
    @Persisted public var paymentLabel: String? = ""
    @Persisted public var isBundleService: String? = ""
    @Persisted public var bundleLabel: String? = ""
    @Persisted public var bundleCategoryLabel: String? = ""
    @Persisted public var isDislayableOnLifestream: String? = ""
    @Persisted public var bundle: String? = ""
    @Persisted public var ignoreSaveEnrollment: String? = ""
    @Persisted public var hasBillAmount: String? = ""
    @Persisted public var displayNoPendingBillDialog: String? = ""
//    @Persisted public var serviceParameters: ServiceParameters? = nil
    @Persisted public var canEditAmount: String? = ""
    @Persisted public var isRefresh: String? = ""
    @Persisted public var favoritesDisplayMode: String? = ""
    @Persisted public var applicableCharges = RealmSwift.List<String>()
    @Persisted public var validateBillAmount: String? = ""
    @Persisted public var charges: String? = ""
    @Persisted public var payerClientID: String? = ""
    @Persisted public var message: String? = ""
    @Persisted public var title: String? = ""
    @Persisted public var isCyclicService: String? = ""
    @Persisted public var exactPayment: String? = ""
    @Persisted public var contractualLevel: String? = ""
    @Persisted public var paymentOptions: String? = ""
    @Persisted public var categoryID: String? = ""
    @Persisted public var category: Categorys?
    @Persisted public var isManualBill: String? = ""
    // service form type dynamic
    public static let GENERIC_FORM = "GENERIC_FORM"
    // service form type dynamic
    public static let DYNAMIC_FORM_TYPE = "DYNAMIC_FORM"
    public static let KPLC_PREPAID_ID = "39"
    public static let SECRET_GARDEN_ID = "235"
    public static let BRITAM_CONTRIBUTION_ID = "515"
    public static let MULA_CHAMA_ID = "187"
    public static let PDSL_PREPAID_ID = "39"
    public static let FAVOURITE_DISPLAY_MODE_SHOW_ALL = "SHOW_ALL"
    public static let FAVOURITE_DISPLAY_MODE_SHOW_PER_OPTION = "SHOW_PER_OPTION"

    enum CodingKeys: String, CodingKey {
        case clientName = "CLIENT_NAME"
        case showAll
        case serviceName = "SERVICE_NAME"
        case serviceCode = "SERVICE_CODE"
        case activeStatus = "ACTIVE_STATUS"
        case serviceLogo = "SERVICE_LOGO"
        case receiverSourceAddress = "RECEIVER_SOURCE_ADDRESS"
        case hubServiceID = "HUB_SERVICE_ID"
        case hubClientID = "HUB_CLIENT_ID"
        case minAmount = "MIN_AMOUNT"
        case abbreviation = "ABBREVIATION"
        case clientCode = "CLIENT_CODE"
        case maxAmount = "MAX_AMOUNT"
        case referenceInputMask = "REFERENCE_INPUT_MASK"
        case formatErrorMessage = "FORMAT_ERROR_MESSAGE"
        case servicePatternID = "SERVICE_PATTERN_ID"
        case isPrepaidService = "IS_PREPAID_SERVICE"
        case paybill = "PAYBILL"
        case networkID = "NETWORK_ID"
        case webTemplateID = "WEB_TEMPLATE_ID"
        case colorCode = "COLOR_CODE"
        case orderID = "ORDER_ID"
        case serviceImage
        case presentmentType = "PRESENTMENT_TYPE"
        case referenceLabel = "REFERENCE_LABEL"
        case inputType = "INPUT_TYPE"
        case formType = "FORM_TYPE"
//        case formParameters = "FORM_PARAMETERS"
        case paymentLabel = "PAYMENT_LABEL"
        case isBundleService = "IS_BUNDLE_SERVICE"
        case bundleLabel = "BUNDLE_LABEL"
        case bundleCategoryLabel = "BUNDLE_CATEGORY_LABEL"
        case isDislayableOnLifestream = "IS_DISLAYABLE_ON_LIFESTREAM"
        case bundle
        case ignoreSaveEnrollment = "IGNORE_SAVE_ENROLLMENT"
        case hasBillAmount = "HAS_BILL_AMOUNT"
        case displayNoPendingBillDialog = "DISPLAY_NO_PENDING_BILL_DIALOG"
//        case serviceParameters = "SERVICE_PARAMETERS"
        case canEditAmount = "CAN_EDIT_AMOUNT"
        case isRefresh = "IS_REFRESH"
        case favoritesDisplayMode = "FAVORITES_DISPLAY_MODE"
        case applicableCharges = "APPLICABLE_CHARGES"
        case validateBillAmount = "VALIDATE_BILL_AMOUNT"
        case charges = "CHARGES"
        case payerClientID = "payerClientId"
        case message = "MESSAGE"
        case title = "TITLE"
        case isCyclicService = "IS_CYCLIC_SERVICE"
        case exactPayment = "EXACT_PAYMENT"
        case contractualLevel = "CONTRACTUAL_LEVEL"
        case paymentOptions = "PAYMENT_OPTIONS"
        case categoryID = "CATEGORY_ID"
        case category, isManualBill
    }
}

// MARK: - SERVICEPARAMETERS
public class ServiceParameters: Object, ObjectKeyIdentifiable, Codable {
    @Persisted public var servicesData = RealmSwift.List<ServicesDatum>()

    enum CodingKeys: String, CodingKey {
        case servicesData = "SERVICES_DATA"
    }
}

 //MARK: - ServicesDatum
public class ServicesDatum: Object, ObjectKeyIdentifiable, Codable {
    @Persisted public var serviceID: Int
    @Persisted public var serviceName: String

    enum CodingKeys: String, CodingKey {
        case serviceID = "SERVICE_ID"
        case serviceName = "SERVICE_NAME"
    }
}
