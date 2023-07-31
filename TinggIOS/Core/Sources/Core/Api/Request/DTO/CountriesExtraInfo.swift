//
//  CountriesExtraInfo.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation

// MARK: - CountriesExtraInfo
public struct CountriesExtraInfo: Codable {
    public let countryURLNew: DynamicType
    public let hotlineAppKey, hotlineAppID: DynamicType
    public let faqURL: DynamicType
    public let tacURL, privacyPolicyURL: DynamicType
    public let excludedSMSSourceAddresses, countryMobileRegex, genericAccountNumberRegex: DynamicType
    public let extractSMSOnProfiling: DynamicType
    public let countryCurrencyRegex, countrySourceAddresses: DynamicType
    public let confirmedAccountLimits: DynamicType
    public let alphanumericRegexes: DynamicType
    public let isDefault: Bool
    public let freshchatAppKey, freshchatAppID, minimumProfiledAccounts, smsProfilingTimeout: DynamicType
    public let roundUpAmounts: String
    public let successCallBackURL: DynamicType
    public let payerClientCode, isSecureCardPayment: DynamicType
    public let failedCallBackURL, webCheckoutURL: DynamicType
    public let countryFlag: DynamicType
    public let maximumCards, clevertapAccountID, clevertapToken: DynamicType
    public let showAssist: DynamicType
    public let mulaAssistInterestType, mulaAssistInterestRate, mulaAssistDurationType, mulaAssistLoanTermDuration: DynamicType
    public let hasWallet, hasGroups, hasFloatingButton, hasDiscover: DynamicType
    public let useSmileSDK, hasReferral: DynamicType
    public let fetchBearerTokenURL, countryURL: String?

    enum CodingKeys: String, CodingKey {
        case countryURLNew = "COUNTRY_URL_NEW"
        case hotlineAppKey = "HOTLINE_APP_KEY"
        case hotlineAppID = "HOTLINE_APP_ID"
        case faqURL = "FAQ_URL"
        case tacURL = "TAC_URL"
        case privacyPolicyURL = "PRIVACY_POLICY_URL"
        case excludedSMSSourceAddresses = "EXCLUDED_SMS_SOURCE_ADDRESSES"
        case countryMobileRegex = "COUNTRY_MOBILE_REGEX"
        case genericAccountNumberRegex = "GENERIC_ACCOUNT_NUMBER_REGEX"
        case extractSMSOnProfiling = "EXTRACT_SMS_ON_PROFILING"
        case countryCurrencyRegex = "COUNTRY_CURRENCY_REGEX"
        case countrySourceAddresses = "COUNTRY_SOURCE_ADDRESSES"
        case confirmedAccountLimits = "CONFIRMED_ACCOUNT_LIMITS"
        case alphanumericRegexes = "ALPHANUMERIC_REGEXES"
        case isDefault = "IS_DEFAULT"
        case freshchatAppKey = "FRESHCHAT_APP_KEY"
        case freshchatAppID = "FRESHCHAT_APP_ID"
        case minimumProfiledAccounts = "MINIMUM_PROFILED_ACCOUNTS"
        case smsProfilingTimeout = "SMS_PROFILING_TIMEOUT"
        case roundUpAmounts = "ROUND_UP_AMOUNTS"
        case successCallBackURL = "SUCCESS_CALL_BACK_URL"
        case payerClientCode = "PAYER_CLIENT_CODE"
        case isSecureCardPayment = "IS_SECURE_CARD_PAYMENT"
        case failedCallBackURL = "FAILED_CALL_BACK_URL"
        case webCheckoutURL = "WEB_CHECKOUT_URL"
        case countryFlag = "COUNTRY_FLAG"
        case maximumCards = "MAXIMUM_CARDS"
        case clevertapAccountID = "CLEVERTAP_ACCOUNT_ID"
        case clevertapToken = "CLEVERTAP_TOKEN"
        case showAssist = "SHOW_ASSIST"
        case mulaAssistInterestType = "MULA_ASSIST_INTEREST_TYPE"
        case mulaAssistInterestRate = "MULA_ASSIST_INTEREST_RATE"
        case mulaAssistDurationType = "MULA_ASSIST_DURATION_TYPE"
        case mulaAssistLoanTermDuration = "MULA_ASSIST_LOAN_TERM_DURATION"
        case hasWallet = "HAS_WALLET"
        case hasGroups = "HAS_GROUPS"
        case hasFloatingButton = "HAS_FLOATING_BUTTON"
        case hasDiscover = "HAS_DISCOVER"
        case useSmileSDK = "USE_SMILE_SDK"
        case hasReferral = "HAS_REFERRAL"
        case fetchBearerTokenURL = "FETCH_BEARER_TOKEN_URL"
        case countryURL = "COUNTRY_URL"
    }
}
