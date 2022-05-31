//
//  MerchantPayer.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation
public class MerchantPayer: Identifiable, Codable {
    public let id: Int = 0
    public let hubClientId: String = "0"
    public let networkId: String? = nil
    public let clientName: String? = nil
    public let serviceCode: String? = nil
    public let payBillNo: String? = nil
    public let activeStatus: String? = nil
    public let logo: String? = nil
    public let viewable: String? = nil
    public let statusMessage: String? = nil
    public let referenceLabel: String? = nil
    public let defaults: String = "0"
    public let orderId: Int = 0
    public let paymentInstruction: String? = nil
    public let merchantPayerEnabled: String? = nil
    public let abbreviation: String? = nil
    public let colorCode: String? = nil
    public let shortName: String? = nil
    public let showLogo: String? = nil
    public let checkoutType: String? = nil
    public let canPayForOther: String? = nil
    public let payerReference: String? = nil
    public let changeSyncMode: String? = nil
    public let paymentCount: String? = nil
    public let isChargingPayer: Bool? = false
    public let payerCharge: String? = nil
    public let alertMessage: String? = nil
    public let alertTitle: String? = nil
    public let paymentActivationDesc: String? = nil
    public let paymentOptionId: String? = nil
    public let clientId: String? = nil
    public let selected: String? = nil
    enum CodingKeys: String, CodingKey {
        case id = "MERCHANT_PAYER_ID"
        case hubClientId = "HUB_CLIENT_ID"
        case networkId = "NETWORK_ID"
        case clientName = "CLIENT_NAME"
        case serviceCode = "CLIENT_CODE"
        case payBillNo = "PAYBILL"
        case activeStatus = "ACTIVE_STATUS"
        case logo = "LOGO"
        case viewable = "VIEWABLE"
        case statusMessage = "STATUS_MESSAGE"
        case referenceLabel = "REFERENCE_LABEL"
        case defaults = "IS_DEFAULT"
        case orderId = "ORDER_ID"
        case paymentInstruction = "PAYMENT_INSTRUCTION"
        case merchantPayerEnabled = "MERCHANT_PAYER_ENABLED"
        case abbreviation = "ABBREVIATION"
        case colorCode = "COLOR_CODE"
        case shortName = "SHORT_NAME"
        case showLogo = "SHOW_LOGO"
        case checkoutType = "CHECKOUT_TYPE"
        case canPayForOther = "CAN_PAY_FOR_OTHER"
        case payerReference = "PAYER_REFERENCE"
        case changeSyncMode = "CHARGE_SYNC_MODE"
        case paymentCount = "PAYMENT_COUNT"
        case isChargingPayer = "IS_CHARGING_PAYER"
        case payerCharge = "PAYER_CHARGE"
        case alertMessage = "MESSAGE"
        case alertTitle = "TITLE"
        case paymentActivationDesc = "PAYMENT_ACTIVATION_DESC"
        case paymentOptionId = "PAYMENT_OPTION_ID"
        case clientId = "CLIENT_ID"
        case selected = "IS_SELECTED"
    }
}
