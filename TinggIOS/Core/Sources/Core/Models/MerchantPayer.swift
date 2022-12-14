//
//  MerchantPayer.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - MerchantPayer
public class MerchantPayer: Object, ObjectKeyIdentifiable, Codable {
    @Persisted public var hubClientID: String? = ""
    @Persisted public var clientName: String? = ""
    @Persisted public var clientCode: String? = ""
    @Persisted public var countryID: String? = ""
    @Persisted public var country: String? = ""
    @Persisted public var activeStatus: String? = ""
    @Persisted public var canPay: String? = ""
    @Persisted public var viewable: String? = ""
    @Persisted public var statusMessage: String? = ""
    @Persisted public var logo: String? = ""
    @Persisted public var webTemplateID: String? = ""
    @Persisted public var paybill: String? = ""
    @Persisted public var networkID: String? = ""
    @Persisted public var referenceLabel: String? = ""
    @Persisted public var isSelected: String? = ""
    @Persisted public var paymentInstructions: String? = ""
    @Persisted public var isDefault: String? = ""
    @Persisted(primaryKey: true) public var orderID: String? = ""
    @Persisted public var paymentInstruction: String? = ""
    @Persisted public var abbreviation: String? = ""
    @Persisted public var colorCode: String? = ""
    @Persisted public var shortName: String? = ""
    @Persisted public var showLogo: String? = ""
    @Persisted public var checkoutType: String? = ""
    @Persisted public var canPayForOther: String? = ""
    @Persisted public var payerReference: String? = ""
    @Persisted public var chargeSyncMode: String? = ""
    @Persisted public var paymentCount: String? = ""
    @Persisted public var isChargingPayer: String? = ""
    @Persisted public var payerCharge: String? = ""
    @Persisted public var title: String? = ""
    @Persisted public var message: String? = ""
    @Persisted public var paymentActivationDesc: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case hubClientID = "HUB_CLIENT_ID"
        case clientName = "CLIENT_NAME"
        case clientCode = "CLIENT_CODE"
        case countryID = "COUNTRY_ID"
        case country = "COUNTRY"
        case activeStatus = "ACTIVE_STATUS"
        case canPay = "CAN_PAY"
//        case viewable = "VIEWABLE"
        case statusMessage = "STATUS_MESSAGE"
        case logo = "LOGO"
        case webTemplateID = "WEB_TEMPLATE_ID"
        case paybill = "PAYBILL"
        case networkID = "NETWORK_ID"
        case referenceLabel = "REFERENCE_LABEL"
//        case isSelected = "IS_SELECTED"
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
}

public struct MerchantPayerStruct: Decodable {
    public var hubClientID: String? = ""
    public var clientName: String? = ""
    public var clientCode: String? = ""
    public var countryID: String? = ""
    public var country: String? = ""
    public var activeStatus: Flex<String, Int>
    public var canPay: String? = ""
    public var viewable: Flex<String, Int>
    public var statusMessage: String? = ""
    public var logo: String? = ""
    public var webTemplateID: String? = ""
    public var paybill: String? = ""
    public var networkID: String? = ""
    public var referenceLabel: String? = ""
    public var isSelected: Flex<String, Int>
    public var paymentInstructions: String? = ""
    public var isDefault: String? = ""
    public var orderID: String? = ""
    public var paymentInstruction: String? = ""
    public var abbreviation: String? = ""
    public var colorCode: String? = ""
    public var shortName: String? = ""
    public var showLogo: String? = ""
    public var checkoutType: String? = ""
    public var canPayForOther: String? = ""
    public var payerReference: String? = ""
    public var chargeSyncMode: String? = ""
    public var paymentCount: String? = ""
    public var isChargingPayer: String? = ""
    public var payerCharge: String? = ""
    public var title: String? = ""
    public var message: String? = ""
    public var paymentActivationDesc: String? = ""
    
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
    
    public func convertToPayer() -> MerchantPayer {
        let p = MerchantPayer()
        p.hubClientID = self.hubClientID
        p.clientName = self.clientName
        p.clientCode = self.clientCode
        p.countryID = self.countryID
        p.country = self.country
        p.activeStatus = String(self.activeStatus.value)
        p.canPay = self.canPay
        p.viewable = String(self.viewable.value)
        p.statusMessage = self.statusMessage
        p.logo = self.logo
        p.webTemplateID = self.webTemplateID
        p.paybill = self.paybill
        p.networkID = self.networkID
        p.referenceLabel = self.referenceLabel
        p.isSelected = String(self.isSelected.value)
        p.paymentInstructions = self.paymentInstructions
        p.isDefault = self.isDefault
        p.orderID = self.orderID
        p.paymentInstruction = self.paymentInstruction
        p.abbreviation = self.abbreviation
        p.colorCode = self.colorCode
        p.shortName = self.shortName
        p.showLogo = self.showLogo
        p.checkoutType = self.checkoutType
        p.canPayForOther = self.canPayForOther
        p.payerReference = self.payerReference
        p.chargeSyncMode = self.chargeSyncMode
        p.paymentCount = self.paymentCount
        p.isChargingPayer = self.isChargingPayer
        p.payerCharge = self.payerCharge
        p.title = self.title
        p.message = self.message
        p.paymentActivationDesc = self.paymentActivationDesc
        return p
        
    }
}
