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
    @Persisted public var id: ObjectId?
    @Persisted public var hubClientID: String? = ""
    @Persisted public var isDefault: String? = ""
    @Persisted public var orderID: Int? = 0
    @Persisted public var isChargingPayer:Bool = false
    @Persisted public var isSelectedOnAdapter: Bool = false
    @Persisted public var merchantPayerDEFAULT: String? = ""
    @Persisted public var selected: String? = ""
    @Persisted public var unSelected: String? = ""
    @Persisted public var chargeTypeFixed: String? = ""
    @Persisted public var chargeTypePercentage: String? = ""
    @Persisted public var checkoutInApp: String? = ""
    @Persisted public var checkoutUssdPush: String? = ""
    @Persisted public var checkoutStkLaunch: String? = ""
    @Persisted public var checkoutCard: String? = ""
    @Persisted public var checkoutBankViaCard: String? = ""
    @Persisted public var checkoutPinAuth: String? = ""
    @Persisted public var checkoutMulaWallet: String? = ""
    @Persisted public var checkoutTinggWallet: String? = ""
    @Persisted public var checkoutTinggFundsTransfer: String? = ""
    @Persisted public var checkoutMnoPinAuth: String? = ""
    
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
//    init(
//        hubClientID: String?, isDefault: String?, orderID: Int,
//          isChargingPayer: Bool, isSelectedOnAdapter: Bool, merchantPayerDEFAULT: String?,
//          selected: String?, unSelected: String?, chargeTypeFixed: String?,
//          chargeTypePercentage: String?, checkoutInApp: String?, checkoutUssdPush: String?,
//          checkoutStkLaunch: String?, checkoutCard: String?, checkoutBankViaCard: String?,
//          checkoutPinAuth: String?, checkoutMulaWallet: String?, checkoutTinggWallet: String?,
//          checkoutTinggFundsTransfer: String?, checkoutMnoPinAuth: String?
//    ) {
//        self.hubClientID = hubClientID
//        self.isDefault = isDefault
//        self.orderID = orderID
//        self.isChargingPayer = isChargingPayer
//        self.isSelectedOnAdapter = isSelectedOnAdapter
//        self.merchantPayerDEFAULT = merchantPayerDEFAULT
//        self.selected = selected
//        self.unSelected = unSelected
//        self.chargeTypeFixed = chargeTypeFixed
//        self.chargeTypePercentage = chargeTypePercentage
//        self.checkoutInApp = checkoutInApp
//        self.checkoutUssdPush = checkoutUssdPush
//        self.checkoutStkLaunch = checkoutStkLaunch
//        self.checkoutCard = checkoutCard
//        self.checkoutBankViaCard = checkoutBankViaCard
//        self.checkoutPinAuth = checkoutPinAuth
//        self.checkoutMulaWallet = checkoutMulaWallet
//        self.checkoutTinggWallet = checkoutTinggWallet
//        self.checkoutTinggFundsTransfer = checkoutTinggFundsTransfer
//        self.checkoutMnoPinAuth = checkoutMnoPinAuth
//    }
}
