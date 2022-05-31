//
//  Country.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation
public class Country : Identifiable, Encodable {
    public let name: String = ""
    public let code: String = ""
    public let url: String? = nil
    public let status: String? = nil
    public let currency: String = ""
    public let clientId: String? = nil
    public let mobileRegex: String? = nil
    public let genericAccountNumberRegex: String? = nil
    public let extractSMS: String? = nil
    public let currencyRegex: String? = nil
    public let excludedSMSSourceAddress: String? = nil
    public let dialCode: String = ""
    public let confirmedAccountLimits: String? = nil
    public let hotlineAppId: String? = nil
    public let hotlineAppKey: String? = nil
    public let freshChatAppId: String? = nil
    public let freshChatAppKey: String? = nil
    public let faqUrl: String? = nil
    public let tacUrl: String? = nil
    public let alphanumericRegex: String? = nil
    public let minimumProfiledAccounts: String? = nil
    public let smsProfilingTimeout: String? = nil
    public let roundUpAmount: String? = nil
    public let maximumCards: String? = nil
    public let flag: String? = nil
    public let hasWallet: Int = 0
    public let hasGroups: Int = 0
    public let hasFloatingButton: Int = 0
    public let hasDiscover: Int = 0
    public let useSmileSdk: String? = nil
    public let hasReferral: Int = 0
    public let manualKycRegistration: Int = 0
    public let sourceAddress: String? = nil
    public let isDefault: Bool = false
    public let successCallbackUrl: String? = nil
    public let payerClietCode: String? = nil
    public let secureCardPayment: String? = nil
    public let failedCallbackUrl: String? = nil
    public let webCheckoutUrl: String? = nil
    public let cleverTapAccountId: String? = nil
    public let cleverTapToken: String? = nil
    public let showAssist: String? = nil
    public let mulaAssistInterestType: String? = nil
    public let mulaAssistDurationType: String? = nil
    public let mulaAssistInterestRate: String? = nil
    public let mulaAssistDuration: String? = nil
    public let mulaAssistLoanTermDuration: String? = nil
    public let accessKey: String? = nil
    public let checkoutServiceCode: String? = nil
    public let webHookUrl: String? = nil
    public let fetchBearerTokenUrl: String? = nil
    public let privacyPolicyUrl: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case name = "COUNTRY"
        case code = "COUNTRY_CODE"
        case url = "COUNTRY_URL_NEW"
        case status = "STATUS"
        case currency = "CURRENCY"
        case clientId = "MULA_CLIENT_ID"
        case mobileRegex = "COUNTRY_MOBILE_REGEX"
        case genericAccountNumberRegex = "GENERIC_ACCOUNT_NUMBER_REGEX"
        case extractSMS = "EXTRACT_SMS_ON_PROFILING"
        case currencyRegex = "COUNTRY_CURRENCY_REGEX"
        case excludedSMSSourceAddress = "EXCLUDED_SMS_SOURCE_ADDRESSES"
        case dialCode = "COUNTRY_DIAL_CODE"
        case confirmedAccountLimits = "CONFIRMED_ACCOUNT_LIMITS"
        case hotlineAppId = "HOTLINE_APP_ID"
        case hotlineAppKey = "HOTLINE_APP_KEY"
        case freshChatAppId = "FRESHCHAT_APP_ID"
        case freshChatAppKey = "FRESHCHAT_APP_KEY"
        case faqUrl = "FAQ_URL"
        case tacUrl = "TAC_URL"
        case alphanumericRegex = "ALPHANUMERIC_REGEXES"
        case minimumProfiledAccounts = "MINIMUM_PROFILED_ACCOUNTS"
        case smsProfilingTimeout = "SMS_PROFILING_TIMEOUT"
        case roundUpAmount = "ROUND_UP_AMOUNTS"
        case maximumCards = "MAXIMUM_CARDS"
        case flag = "COUNTRY_FLAG"
        case hasWallet = "HAS_WALLET"
        case hasGroups = "HAS_GROUPS"
        case hasFloatingButton = "HAS_FLOATING_BUTTON"
        case hasDiscover = "HAS_DISCOVER"
        case useSmileSdk = "USE_SMILE_SDK"
        case hasReferral = "HAS_REFERRAL"
        case manualKycRegistration = "IS_MANUAL_KYC_REGISTRATION"
        case sourceAddress = "COUNTRY_SOURCE_ADDRESSES"
        case isDefault = "IS_DEFAULT"
        case successCallbackUrl = "SUCCESS_CALL_BACK_URL"
        case payerClietCode = "PAYER_CLIENT_CODE"
        case secureCardPayment = "IS_SECURE_CARD_PAYMENT"
        case failedCallbackUrl = "FAILED_CALL_BACK_URL"
        case webCheckoutUrl = "WEB_CHECKOUT_URL"
        case cleverTapAccountId = "CLEVERTAP_ACCOUNT_ID"
        case cleverTapToken = "CLEVERTAP_TOKEN"
        case showAssist = "SHOW_ASSIST"
        case mulaAssistInterestType = "MULA_ASSIST_INTEREST_TYPE"
        case mulaAssistDurationType = "MULA_ASSIST_DURATION_TYPE"
        case mulaAssistInterestRate = "MULA_ASSIST_INTEREST_RATE"
        case mulaAssistDuration = "MULA_ASSIST_DURATION"
        case mulaAssistLoanTermDuration = "MULA_ASSIST_LOAN_TERM_DURATION"
        case accessKey = "ACCESS_KEY"
        case checkoutServiceCode = "CHECKOUT_SERVICE_CODE"
        case webHookUrl = "WEB_HOOK_URL"
        case fetchBearerTokenUrl = "FETCH_BEARER_TOKEN_URL"
        case privacyPolicyUrl = "PRIVACY_POLICY_URL"
        
    }
}
