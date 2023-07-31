//
//  ServiceDTO.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
// MARK: - ServiceDTO
public struct ServiceDTO: Codable {
    public let serviceName, clientName, hubClientID, serviceCode: String
    public let hubServiceID, clientCode, minAmount, maxAmount: String
    public let servicePatternID, serviceAccountKey: String
    public let exactPayment: String
    public let categoryID: StringOrIntEnum
    public let activeStatus: String
    public let serviceLogo: String
    public let isPrepaidService, paybill, networkID, webTemplateID: String
    public let receiverSourceAddress, referenceLabel: String
    public let presentmentType: PresentmentType
    public let referenceInputMask, formatErrorMessage: String
    public let inputType: String
    public let colorCode: String
    public let formType: String
    public let formParameters: FORMPARAMETERSDTO
    public let abbreviation: String
    public let paymentLabel: String
    public let orderID, regexType, isBundleService, ignoreSaveEnrollment: String
    public let hasBillAmount: String
    public let serviceParameters: SERVICEPARAMETERSDTO
    public let bundleLabel: String
    public let bundleCategoryLabel: String
    public let displayNoPendingBillDialog, canEditAmount, isCyclicService, isDislayableOnLifestream: String
    public let favoritesDisplayMode: String
    public let isRefresh: String
    public let applicableCharges: [String] = []
    public let validateBillAmount: String
    public let charges: String
    public let title: String
    public let message: String

    public init(
        serviceName: String = "", clientName: String = "", hubClientID: String = "", serviceCode: String = "", hubServiceID: String = "", clientCode: String = "", minAmount: String = "", maxAmount: String = "", servicePatternID: String = "", serviceAccountKey: String = "", exactPayment: String = "", categoryID: StringOrIntEnum = .string(""), activeStatus: String = "", serviceLogo: String = "", isPrepaidService: String = "", paybill: String = "", networkID: String = "", webTemplateID: String = "", receiverSourceAddress: String = "", referenceLabel: String = "", presentmentType: PresentmentType, referenceInputMask: String = "", formatErrorMessage: String = "", inputType: String = "", colorCode: String = "", formType: String = "", formParameters: FORMPARAMETERSDTO = .string(""), abbreviation: String = "", paymentLabel: String = "", orderID: String = "", regexType: String = "", isBundleService: String = "", ignoreSaveEnrollment: String = "", hasBillAmount: String = "", serviceParameters: SERVICEPARAMETERSDTO = .string(""), bundleLabel: String = "", bundleCategoryLabel: String = "", displayNoPendingBillDialog: String = "", canEditAmount: String = "", isCyclicService: String = "", isDislayableOnLifestream: String = "", favoritesDisplayMode: String = "", isRefresh: String = "", validateBillAmount: String = "", charges: String = "", title: String = "", message: String = ""
    ) {
        self.serviceName = serviceName
        self.clientName = clientName
        self.hubClientID = hubClientID
        self.serviceCode = serviceCode
        self.hubServiceID = hubServiceID
        self.clientCode = clientCode
        self.minAmount = minAmount
        self.maxAmount = maxAmount
        self.servicePatternID = servicePatternID
        self.serviceAccountKey = serviceAccountKey
        self.exactPayment = exactPayment
        self.categoryID = categoryID
        self.activeStatus = activeStatus
        self.serviceLogo = serviceLogo
        self.isPrepaidService = isPrepaidService
        self.paybill = paybill
        self.networkID = networkID
        self.webTemplateID = webTemplateID
        self.receiverSourceAddress = receiverSourceAddress
        self.referenceLabel = referenceLabel
        self.presentmentType = presentmentType
        self.referenceInputMask = referenceInputMask
        self.formatErrorMessage = formatErrorMessage
        self.inputType = inputType
        self.colorCode = colorCode
        self.formType = formType
        self.formParameters = formParameters
        self.abbreviation = abbreviation
        self.paymentLabel = paymentLabel
        self.orderID = orderID
        self.regexType = regexType
        self.isBundleService = isBundleService
        self.ignoreSaveEnrollment = ignoreSaveEnrollment
        self.hasBillAmount = hasBillAmount
        self.serviceParameters = serviceParameters
        self.bundleLabel = bundleLabel
        self.bundleCategoryLabel = bundleCategoryLabel
        self.displayNoPendingBillDialog = displayNoPendingBillDialog
        self.canEditAmount = canEditAmount
        self.isCyclicService = isCyclicService
        self.isDislayableOnLifestream = isDislayableOnLifestream
        self.favoritesDisplayMode = favoritesDisplayMode
        self.isRefresh = isRefresh
        self.validateBillAmount = validateBillAmount
        self.charges = charges
        self.title = title
        self.message = message
    }
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
   public var toEntity: MerchantService {
        let entity = MerchantService()
        entity.serviceName = self.serviceName
        entity.clientName = self.clientName
        entity.clientCode = self.clientCode
        entity.serviceCode = self.serviceCode
        entity.hubClientID = self.hubClientID
        entity.hubServiceID = self.hubServiceID
        entity.minAmount = self.minAmount
        entity.maxAmount = self.maxAmount
        entity.servicePatternID = self.servicePatternID
        entity.serviceAccountKey = self.serviceAccountKey
        entity.exactPayment = self.exactPayment
        entity.categoryID = self.categoryID.toString
        entity.activeStatus = self.activeStatus
        entity.serviceLogo = self.serviceLogo
        entity.isPrepaidService = self.isPrepaidService
        entity.paybill = self.paybill
        entity.networkID = self.networkID
        entity.webTemplateID = self.webTemplateID
        entity.receiverSourceAddress = self.receiverSourceAddress
        entity.referenceLabel = self.referenceLabel
        entity.formatErrorMessage = self.formatErrorMessage
        entity.inputType = self.inputType
        entity.colorCode = self.colorCode
        entity.formType = self.formType
        entity.formParameters = self.formParameters.toEntity
        entity.abbreviation = self.abbreviation
        entity.paymentLabel = self.paymentLabel
        entity.orderID = self.orderID
        entity.regexType = self.regexType
        entity.isBundleService = self.isBundleService
        entity.ignoreSaveEnrollment = self.ignoreSaveEnrollment
        entity.hasBillAmount = self.hasBillAmount
        entity.serviceParameters = self.serviceParameters.toEntity
        entity.bundleLabel = self.bundleLabel
        entity.bundleCategoryLabel = self.bundleCategoryLabel
        entity.displayNoPendingBillDialog = self.displayNoPendingBillDialog
        entity.favoritesDisplayMode = self.favoritesDisplayMode
        entity.isRefresh = self.isRefresh
        let applicableChargeList: [String] = self.applicableCharges.map {$0}
        entity.applicableCharges.append(objectsIn: applicableChargeList)
        entity.validateBillAmount = self.validateBillAmount
        entity.charges = self.charges
        entity.title = self.title
        entity.message = self.message
        entity.presentmentType = self.presentmentType.rawValue
        return entity
    }
    public var isActive: Bool {
        return self.activeStatus == "0" ? false : true
    }
}

