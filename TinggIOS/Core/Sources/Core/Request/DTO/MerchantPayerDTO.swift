//
//  MerchantPayerDTO.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
// MARK: - MerchantPayerDTO
public struct MerchantPayerDTO: Codable {
    public let hubClientID, clientName, clientCode, countryID: String
    public let country, activeStatus, canPay, viewable: DynamicType
    public let statusMessage: String
    public let logo: String
    public let webTemplateID: String?
    public let paybill, networkID, referenceLabel: String
    public let isSelected: StringOrIntEnum
    public let paymentInstructions, isDefault, orderID, paymentInstruction: String
    public let abbreviation, colorCode, shortName, showLogo: String
    public let checkoutType, canPayForOther, payerReference, chargeSyncMode: String
    public let paymentCount: String
    public let isChargingPayer: String
    public let payerCharge, title, message, paymentActivationDesc: String

    enum CodingKeys: String, CodingKey {
        case hubClientID = "HUB_CLIENT_ID"
        case clientName = "CLIENT_NAME"
        case clientCode = "CLIENT_CODE"
        case countryID = "COUNTRY_ID"
        case country = "COUNTRY"
        case activeStatus = "ACTIVE_STATUS"
        case canPay = "CAN_PAY"
        case viewable = "VIEWABLE"
        case statusMessage = "STATUS_MESSAGE"
        case logo = "LOGO"
        case webTemplateID = "WEB_TEMPLATE_ID"
        case paybill = "PAYBILL"
        case networkID = "NETWORK_ID"
        case referenceLabel = "REFERENCE_LABEL"
        case isSelected = "IS_SELECTED"
        case paymentInstructions = "PAYMENT_INSTRUCTIONS"
        case isDefault = "IS_DEFAULT"
        case orderID = "ORDER_ID"
        case paymentInstruction = "PAYMENT_INSTRUCTION"
        case abbreviation = "ABBREVIATION"
        case colorCode = "COLOR_CODE"
        case shortName = "SHORT_NAME"
        case showLogo = "SHOW_LOGO"
        case checkoutType = "CHECKOUT_TYPE"
        case canPayForOther = "CAN_PAY_FOR_OTHER"
        case payerReference = "PAYER_REFERENCE"
        case chargeSyncMode = "CHARGE_SYNC_MODE"
        case paymentCount = "PAYMENT_COUNT"
        case isChargingPayer = "IS_CHARGING_PAYER"
        case payerCharge = "PAYER_CHARGE"
        case title = "TITLE"
        case message = "MESSAGE"
        case paymentActivationDesc = "PAYMENT_ACTIVATION_DESC"
    }
    public var toEntity: MerchantPayer {
        let entity = MerchantPayer()
        entity.hubClientID = self.hubClientID
        entity.clientName = self.clientName
        entity.clientCode = self.clientCode
        entity.countryID = self.countryID
        entity.country = self.country.toString
        entity.activeStatus = self.activeStatus.toString
        entity.canPay = self.canPay.toString
        entity.viewable = self.viewable.toString
        entity.statusMessage = self.statusMessage
        entity.logo = self.logo
        entity.webTemplateID = self.webTemplateID.rawValue
        entity.paybill = self.paybill
        entity.networkID = self.networkID
        entity.referenceLabel = self.referenceLabel
        entity.isSelected = self.isSelected.toString
        entity.paymentInstructions = self.paymentInstructions
        entity.isDefault = self.isDefault
        entity.orderID = self.orderID
        entity.paymentInstruction = self.paymentInstruction
        entity.abbreviation = self.abbreviation
        entity.colorCode = self.colorCode
        entity.shortName = self.shortName
        entity.showLogo = self.showLogo
        entity.checkoutType = self.checkoutType
        entity.canPayForOther = self.canPayForOther
        entity.payerReference = self.payerReference
        entity.chargeSyncMode = self.chargeSyncMode
        entity.paymentCount = self.paymentCount
        entity.isChargingPayer = self.isChargingPayer
        entity.payerCharge = self.payerCharge
        entity.title = self.title
        entity.message = self.message
        entity.paymentActivationDesc = self.paymentActivationDesc
        return entity
    }
}
