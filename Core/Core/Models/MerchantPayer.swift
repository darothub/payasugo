//
//  MerchantPayer.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation

// MARK: - MerchantPayer
public class MerchantPayer: Identifiable, Codable {
    public let id: Int
    public let hubClientID, isDefault: String?
    public let orderID: Int
    public let isChargingPayer, isSelectedOnAdapter: Bool
    public let merchantPayerDEFAULT, selected, unSelected, chargeTypeFixed: String?
    public let chargeTypePercentage, checkoutInApp, checkoutUssdPush, checkoutStkLaunch: String?
    public let checkoutCard, checkoutBankViaCard, checkoutPinAuth, checkoutMulaWallet: String?
    public let checkoutTinggWallet, checkoutTinggFundsTransfer, checkoutMnoPinAuth: String?

    enum CodingKeys: String, CodingKey {
        case id
        case hubClientID = "HUB_CLIENT_ID"
        case isDefault = "IS_DEFAULT"
        case orderID = "ORDER_ID"
        case isChargingPayer = "IS_CHARGING_PAYER"
        case isSelectedOnAdapter
        case merchantPayerDEFAULT = "DEFAULT"
        case selected = "SELECTED"
        case unSelected = "UN_SELECTED"
        case chargeTypeFixed = "CHARGE_TYPE_FIXED"
        case chargeTypePercentage = "CHARGE_TYPE_PERCENTAGE"
        case checkoutInApp = "CHECKOUT_IN_APP"
        case checkoutUssdPush = "CHECKOUT_USSD_PUSH"
        case checkoutStkLaunch = "CHECKOUT_STK_LAUNCH"
        case checkoutCard = "CHECKOUT_CARD"
        case checkoutBankViaCard = "CHECKOUT_BANK_VIA_CARD"
        case checkoutPinAuth = "CHECKOUT_PIN_AUTH"
        case checkoutMulaWallet = "CHECKOUT_MULA_WALLET"
        case checkoutTinggWallet = "CHECKOUT_TINGG_WALLET"
        case checkoutTinggFundsTransfer = "CHECKOUT_TINGG_FUNDS_TRANSFER"
        case checkoutMnoPinAuth = "CHECKOUT_MNO_PIN_AUTH"
    }

    init(id: Int = 0, hubClientID: String?, isDefault: String?, orderID: Int, isChargingPayer: Bool, isSelectedOnAdapter: Bool, merchantPayerDEFAULT: String?, selected: String?, unSelected: String?, chargeTypeFixed: String?, chargeTypePercentage: String?, checkoutInApp: String?, checkoutUssdPush: String?, checkoutStkLaunch: String?, checkoutCard: String?, checkoutBankViaCard: String?, checkoutPinAuth: String?, checkoutMulaWallet: String?, checkoutTinggWallet: String?, checkoutTinggFundsTransfer: String?, checkoutMnoPinAuth: String?) {
        self.id = id
        self.hubClientID = hubClientID
        self.isDefault = isDefault
        self.orderID = orderID
        self.isChargingPayer = isChargingPayer
        self.isSelectedOnAdapter = isSelectedOnAdapter
        self.merchantPayerDEFAULT = merchantPayerDEFAULT
        self.selected = selected
        self.unSelected = unSelected
        self.chargeTypeFixed = chargeTypeFixed
        self.chargeTypePercentage = chargeTypePercentage
        self.checkoutInApp = checkoutInApp
        self.checkoutUssdPush = checkoutUssdPush
        self.checkoutStkLaunch = checkoutStkLaunch
        self.checkoutCard = checkoutCard
        self.checkoutBankViaCard = checkoutBankViaCard
        self.checkoutPinAuth = checkoutPinAuth
        self.checkoutMulaWallet = checkoutMulaWallet
        self.checkoutTinggWallet = checkoutTinggWallet
        self.checkoutTinggFundsTransfer = checkoutTinggFundsTransfer
        self.checkoutMnoPinAuth = checkoutMnoPinAuth
    }
}
