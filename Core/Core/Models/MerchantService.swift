//
//  MerchantService.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation
public class MerchantServices: Codable {
    public let hubServiceID: String
    public let isDislayableOnLifestream, isRefresh, isCyclicService: Bool
    public let isManualBill: String
    public let selected: Bool
    public let genericForm, dynamicFormType, kplcPrepaidID, secretGardenID: String
    public let britamContributionID, mulaChamaID, pdslPrepaidID, favouriteDisplayModeShowAll: String
    public let favouriteDisplayModeShowPerOption: String

    enum CodingKeys: String, CodingKey {
        case hubServiceID = "HUB_SERVICE_ID"
        case isDislayableOnLifestream = "IS_DISLAYABLE_ON_LIFESTREAM"
        case isRefresh = "IS_REFRESH"
        case isCyclicService = "IS_CYCLIC_SERVICE"
        case isManualBill, selected
        case genericForm = "GENERIC_FORM"
        case dynamicFormType = "DYNAMIC_FORM_TYPE"
        case kplcPrepaidID = "KPLC_PREPAID_ID"
        case secretGardenID = "SECRET_GARDEN_ID"
        case britamContributionID = "BRITAM_CONTRIBUTION_ID"
        case mulaChamaID = "MULA_CHAMA_ID"
        case pdslPrepaidID = "PDSL_PREPAID_ID"
        case favouriteDisplayModeShowAll = "FAVOURITE_DISPLAY_MODE_SHOW_ALL"
        case favouriteDisplayModeShowPerOption = "FAVOURITE_DISPLAY_MODE_SHOW_PER_OPTION"
    }
}

// MARK: - MerchantService
public class MerchantService: Identifiable, Codable {
    public let clientName, showAll, serviceName, serviceCode: String?
    public let activeStatus, serviceLogo, receiverSourceAddress, hubServiceID: String?
    public let hubClientID, minAmount, abbreviation, clientCode: String?
    public let maxAmount, referenceInputMask, formatErrorMessage, servicePatternID: String?
    public let isPrepaidService, paybill, networkID, webTemplateID: String?
    public let colorCode, orderID, serviceImage, presentmentType: String?
    public let referenceLabel, inputType, formType, formParameters: String?
    public let paymentLabel, isBundleService, bundleLabel, bundleCategoryLabel: String?
    public let isDislayableOnLifestream: Bool
    public let bundle, ignoreSaveEnrollment, hasBillAmount, displayNoPendingBillDialog: String?
    public let serviceParameters, canEditAmount: String?
    public let isRefresh: Bool
    public let favoritesDisplayMode, applicableCharges, validateBillAmount, charges: String?
    public let payerClientID, message, title: String?
    public let isCyclicService: Bool
    public let exactPayment, contractualLevel, paymentOptions, categoryID: String?
    public let category: Category?
    public let isManualBill: String?
    public let selected: Bool
    
    //service form type dynamic
    public static let GENERIC_FORM = "GENERIC_FORM"
    //service form type dynamic
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
        case formParameters = "FORM_PARAMETERS"
        case paymentLabel = "PAYMENT_LABEL"
        case isBundleService = "IS_BUNDLE_SERVICE"
        case bundleLabel = "BUNDLE_LABEL"
        case bundleCategoryLabel = "BUNDLE_CATEGORY_LABEL"
        case isDislayableOnLifestream = "IS_DISLAYABLE_ON_LIFESTREAM"
        case bundle
        case ignoreSaveEnrollment = "IGNORE_SAVE_ENROLLMENT"
        case hasBillAmount = "HAS_BILL_AMOUNT"
        case displayNoPendingBillDialog = "DISPLAY_NO_PENDING_BILL_DIALOG"
        case serviceParameters = "SERVICE_PARAMETERS"
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
        case category, isManualBill, selected
    }

    init(clientName: String?, showAll: String?, serviceName: String?, serviceCode: String?, activeStatus: String?, serviceLogo: String?, receiverSourceAddress: String?, hubServiceID: String?, hubClientID: String?, minAmount: String?, abbreviation: String?, clientCode: String?, maxAmount: String?, referenceInputMask: String?, formatErrorMessage: String?, servicePatternID: String?, isPrepaidService: String?, paybill: String?, networkID: String?, webTemplateID: String?, colorCode: String?, orderID: String?, serviceImage: String?, presentmentType: String?, referenceLabel: String?, inputType: String?, formType: String?, formParameters: String?, paymentLabel: String?, isBundleService: String?, bundleLabel: String?, bundleCategoryLabel: String?, isDislayableOnLifestream: Bool, bundle: String?, ignoreSaveEnrollment: String?, hasBillAmount: String?, displayNoPendingBillDialog: String?, serviceParameters: String?, canEditAmount: String?, isRefresh: Bool, favoritesDisplayMode: String?, applicableCharges: String?, validateBillAmount: String?, charges: String?, payerClientID: String?, message: String?, title: String?, isCyclicService: Bool, exactPayment: String?, contractualLevel: String?, paymentOptions: String?, categoryID: String?, category: Category?) {
        self.clientName = clientName
        self.showAll = showAll
        self.serviceName = serviceName
        self.serviceCode = serviceCode
        self.activeStatus = activeStatus
        self.serviceLogo = serviceLogo
        self.receiverSourceAddress = receiverSourceAddress
        self.hubServiceID = hubServiceID
        self.hubClientID = hubClientID
        self.minAmount = minAmount
        self.abbreviation = abbreviation
        self.clientCode = clientCode
        self.maxAmount = maxAmount
        self.referenceInputMask = referenceInputMask
        self.formatErrorMessage = formatErrorMessage
        self.servicePatternID = servicePatternID
        self.isPrepaidService = isPrepaidService
        self.paybill = paybill
        self.networkID = networkID
        self.webTemplateID = webTemplateID
        self.colorCode = colorCode
        self.orderID = orderID
        self.serviceImage = serviceImage
        self.presentmentType = presentmentType
        self.referenceLabel = referenceLabel
        self.inputType = inputType
        self.formType = formType
        self.formParameters = formParameters
        self.paymentLabel = paymentLabel
        self.isBundleService = isBundleService
        self.bundleLabel = bundleLabel
        self.bundleCategoryLabel = bundleCategoryLabel
        self.isDislayableOnLifestream = isDislayableOnLifestream
        self.bundle = bundle
        self.ignoreSaveEnrollment = ignoreSaveEnrollment
        self.hasBillAmount = hasBillAmount
        self.displayNoPendingBillDialog = displayNoPendingBillDialog
        self.serviceParameters = serviceParameters
        self.canEditAmount = canEditAmount
        self.isRefresh = isRefresh
        self.favoritesDisplayMode = favoritesDisplayMode
        self.applicableCharges = applicableCharges
        self.validateBillAmount = validateBillAmount
        self.charges = charges
        self.payerClientID = payerClientID
        self.message = message
        self.title = title
        self.isCyclicService = isCyclicService
        self.exactPayment = exactPayment
        self.contractualLevel = contractualLevel
        self.paymentOptions = paymentOptions
        self.categoryID = categoryID
        self.category = category
        self.isManualBill = "0"
        self.selected = false
    }
}
