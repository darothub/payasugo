//
//  File.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
// MARK: - ServiceDTO
public struct ServiceDTO: Codable {
    public let serviceName, clientName, hubClientID, serviceCode: DynamicType
    public let hubServiceID, clientCode, minAmount, maxAmount: DynamicType
    public let servicePatternID, serviceAccountKey: DynamicType
    public let exactPayment: String
    public let categoryID: StringOrIntEnum
    public let activeStatus: DynamicType
    public let serviceLogo: DynamicType
    public let isPrepaidService, paybill, networkID, webTemplateID: DynamicType
    public let receiverSourceAddress, referenceLabel: DynamicType
    public let presentmentType: PresentmentType
    public let referenceInputMask, formatErrorMessage: DynamicType
    public let inputType: InputType
    public let colorCode: DynamicType
    public let formType: FormType
    public let formParameters: FORMPARAMETERSDTO
    public let abbreviation: DynamicType
    public let paymentLabel: String
    public let orderID, regexType, isBundleService, ignoreSaveEnrollment: DynamicType
    public let hasBillAmount: DynamicType
    public let serviceParameters: SERVICEPARAMETERSDTO
    public let bundleLabel: String
    public let bundleCategoryLabel: String
    public let displayNoPendingBillDialog, canEditAmount, isCyclicService, isDislayableOnLifestream: DynamicType
    public let favoritesDisplayMode: String
    public let isRefresh: String
    public let applicableCharges: [DynamicType]
    public let validateBillAmount: String
    public let charges: DynamicType
    public let title: DynamicType
    public let message: DynamicType

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
        entity.serviceName = self.serviceName.toString
        entity.clientName = self.clientName.toString
        entity.clientCode = self.clientCode.toString
        entity.serviceCode = self.serviceCode.toString
        entity.hubClientID = self.hubClientID.toString
        entity.hubServiceID = self.hubServiceID.toString
        entity.minAmount = self.minAmount.toString
        entity.maxAmount = self.maxAmount.toString
        entity.servicePatternID = self.servicePatternID.toString
        entity.serviceAccountKey = self.serviceAccountKey.toString
        entity.exactPayment = self.exactPayment
        entity.categoryID = self.categoryID.toString
        entity.activeStatus = self.activeStatus.toString
        entity.serviceLogo = self.serviceLogo.toString
        entity.isPrepaidService = self.isPrepaidService.toString
        entity.paybill = self.paybill.toString
        entity.networkID = self.networkID.toString
        entity.webTemplateID = self.webTemplateID.toString
        entity.receiverSourceAddress = self.receiverSourceAddress.toString
        entity.referenceLabel = self.referenceLabel.toString
        entity.formatErrorMessage = self.formatErrorMessage.toString
        entity.inputType = self.inputType.rawValue
        entity.colorCode = self.colorCode.toString
        entity.formType = self.formType.rawValue
        entity.formParameters = self.formParameters.toEntity
        entity.abbreviation = self.abbreviation.toString
        entity.paymentLabel = self.paymentLabel
        entity.orderID = self.orderID.toString
        entity.regexType = self.regexType.toString
        entity.isBundleService = self.isBundleService.toString
        entity.ignoreSaveEnrollment = self.ignoreSaveEnrollment.toString
        entity.hasBillAmount = self.hasBillAmount.toString
        entity.serviceParameters = self.serviceParameters.toEntity
        entity.bundleLabel = self.bundleLabel
        entity.bundleCategoryLabel = self.bundleCategoryLabel
        entity.displayNoPendingBillDialog = self.displayNoPendingBillDialog.toString
        entity.favoritesDisplayMode = self.favoritesDisplayMode
        entity.isRefresh = self.isRefresh
        let applicableChargeList: [String] = self.applicableCharges.map {$0.toString}
        entity.applicableCharges.append(objectsIn: applicableChargeList)
        entity.validateBillAmount = self.validateBillAmount
        entity.charges = self.charges.value as? String ?? ""
        entity.title = self.title.value as? String ?? ""
        entity.message = self.message.value as? String ?? ""
        entity.presentmentType = self.presentmentType.rawValue
        return entity
    }
    public var isActive: Bool {
        return self.activeStatus.toString == "0" ? false : true
    }
}
