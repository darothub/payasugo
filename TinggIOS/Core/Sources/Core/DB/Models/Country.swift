//
//  Country.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift

// MARK: - Country
public class Country: Object, DBObject, ObjectKeyIdentifiable, Codable {
    @Persisted public var name: String? = ""
    @Persisted(primaryKey: true) public var countryCode: String? = ""
    @Persisted public var countryURLNew: String? = ""
    @Persisted public var status: String? = ""
    @Persisted public var currency: String? = ""
    @Persisted public var mulaClientID: String? = ""
    @Persisted public var countryMobileRegex: String? = ""
    @Persisted public var genericAccountNumberRegex: String? = ""
//    @Persisted public var extractSMSOnProfiling = 0
    @Persisted public var countryCurrencyRegex: String? = ""
//    @Persisted public var excludedSMSSourceAddresses = RealmSwift.List<String>()
    @Persisted public var countryDialCode: String? = ""
//    @Persisted public var confirmedAccountLimits: String? = ""
    @Persisted public var hotlineAppID: String? = ""
    @Persisted public var hotlineAppKey: String? = ""
    @Persisted public var freshchatAppID: String? = ""
    @Persisted public var freshchatAppKey: String? = ""
    @Persisted public var faqURL: String? = ""
    @Persisted public var tacURL: String? = ""
    @Persisted public var alphanumericRegexes: String? = ""
    @Persisted public var minimumProfiledAccounts: String? = ""
    @Persisted public var smsProfilingTimeout: String? = ""
    @Persisted public var roundUpAmounts: String? = ""
    @Persisted public var maximumCards: String? = ""
    @Persisted public var countryFlag: String? = ""
    @Persisted public var hasWallet: Int? = 0
    @Persisted public var hasGroups: Int? = 0
    @Persisted public var hasFloatingButton: Int? = 0
//    @Persisted public var hasDiscover: Int = 0
    @Persisted public var useSmileSDK: Int? = 0
    @Persisted public var hasReferral: Int? = 0
//    @Persisted public var isManualKycRegistration: Int = 0
    @Persisted public var countrySourceAddresses: String? = ""
    @Persisted public var isDefault: Bool? = false
    @Persisted public var successCallBackURL: String? = ""
    @Persisted public var payerClientCode: String? = ""
//    @Persisted public var isSecureCardPayment: String? = ""
    @Persisted public var failedCallBackURL: String? = ""
    @Persisted public var webCheckoutURL: String? = ""
    @Persisted public var clevertapAccountID: String? = ""
    @Persisted public var clevertapToken: String? = ""
    @Persisted public var showAssist: Int? = 0
    @Persisted public var mulaAssistInterestType: String? = ""
    @Persisted public var mulaAssistDurationType: String? = ""
    @Persisted public var mulaAssistInterestRate: String? = ""
    @Persisted public var mulaAssistDuration: String? = ""
    @Persisted public var mulaAssistLoanTermDuration: String? = ""
    @Persisted public var accessKey: String? = ""
    @Persisted public var checkoutServiceCode: String? = ""
    @Persisted public var webHookURL: String? = ""
    @Persisted public var fetchBearerTokenURL: String? = ""
    @Persisted public var privacyPolicyURL: String? = ""
    @Persisted public var activeCountry: Bool = false
    enum CodingKeys: String, CodingKey {
        case name = "COUNTRY"
        case countryCode = "COUNTRY_CODE"
        case countryURLNew = "COUNTRY_URL"
        case status = "STATUS"
        case currency = "CURRENCY"
        case mulaClientID = "MULA_CLIENT_ID"
        case countryMobileRegex = "COUNTRY_MOBILE_REGEX"
        case genericAccountNumberRegex = "GENERIC_ACCOUNT_NUMBER_REGEX"
//        case extractSMSOnProfiling = "EXTRACT_SMS_ON_PROFILING"
        case countryCurrencyRegex = "COUNTRY_CURRENCY_REGEX"
//        case excludedSMSSourceAddresses = "EXCLUDED_SMS_SOURCE_ADDRESSES"
        case countryDialCode = "COUNTRY_DIAL_CODE"
//        case confirmedAccountLimits = "CONFIRMED_ACCOUNT_LIMITS"
        case hotlineAppID = "HOTLINE_APP_ID"
        case hotlineAppKey = "HOTLINE_APP_KEY"
        case freshchatAppID = "FRESHCHAT_APP_ID"
        case freshchatAppKey = "FRESHCHAT_APP_KEY"
        case faqURL = "FAQ_URL"
        case tacURL = "TAC_URL"
        case alphanumericRegexes = "ALPHANUMERIC_REGEXES"
        case minimumProfiledAccounts = "MINIMUM_PROFILED_ACCOUNTS"
        case smsProfilingTimeout = "SMS_PROFILING_TIMEOUT"
        case roundUpAmounts = "ROUND_UP_AMOUNTS"
        case maximumCards = "MAXIMUM_CARDS"
        case countryFlag = "COUNTRY_FLAG"
        case hasWallet = "HAS_WALLET"
        case hasGroups = "HAS_GROUPS"
        case hasFloatingButton = "HAS_FLOATING_BUTTON"
//        case hasDiscover = "HAS_DISCOVER"
        case useSmileSDK = "USE_SMILE_SDK"
        case hasReferral = "HAS_REFERRAL"
//        case isManualKycRegistration = "IS_MANUAL_KYC_REGISTRATION"
        case countrySourceAddresses = "COUNTRY_SOURCE_ADDRESSES"
        case isDefault = "IS_DEFAULT"
        case successCallBackURL = "SUCCESS_CALL_BACK_URL"
        case payerClientCode = "PAYER_CLIENT_CODE"
//        case isSecureCardPayment = "IS_SECURE_CARD_PAYMENT"
        case failedCallBackURL = "FAILED_CALL_BACK_URL"
        case webCheckoutURL = "WEB_CHECKOUT_URL"
        case clevertapAccountID = "CLEVERTAP_ACCOUNT_ID"
        case clevertapToken = "CLEVERTAP_TOKEN"
        case showAssist = "SHOW_ASSIST"
        case mulaAssistInterestType = "MULA_ASSIST_INTEREST_TYPE"
        case mulaAssistDurationType = "MULA_ASSIST_DURATION_TYPE"
        case mulaAssistInterestRate = "MULA_ASSIST_INTEREST_RATE"
        case mulaAssistDuration = "MULA_ASSIST_DURATION"
        case mulaAssistLoanTermDuration = "MULA_ASSIST_LOAN_TERM_DURATION"
        case accessKey = "ACCESS_KEY"
        case checkoutServiceCode = "CHECKOUT_SERVICE_CODE"
        case webHookURL = "WEB_HOOK_URL"
        case fetchBearerTokenURL = "FETCH_BEARER_TOKEN_URL"
        case privacyPolicyURL = "PRIVACY_POLICY_URL"
    }
}
