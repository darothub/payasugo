//
//  Country.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation
import RealmSwift

// MARK: - Country
public class Country: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted public var country: String?
    @Persisted public var countryCode: String?
    @Persisted public var countryURLNew: String?
    @Persisted public var status: String?
    @Persisted public var currency: String?
    @Persisted public var mulaClientID: String?
    @Persisted public var countryMobileRegex: String?
    @Persisted public var genericAccountNumberRegex: String?
    @Persisted public var extractSMSOnProfiling: String?
    @Persisted public var countryCurrencyRegex: String?
    @Persisted public var excludedSMSSourceAddresses: String?
    @Persisted public var countryDialCode: String?
    @Persisted public var confirmedAccountLimits: String?
    @Persisted public var hotlineAppID: String?
    @Persisted public var hotlineAppKey: String?
    @Persisted public var freshchatAppID: String?
    @Persisted public var freshchatAppKey: String?
    @Persisted public var faqURL: String?
    @Persisted public var tacURL: String?
    @Persisted public var alphanumericRegexes: String?
    @Persisted public var minimumProfiledAccounts: String?
    @Persisted public var smsProfilingTimeout: String?
    @Persisted public var roundUpAmounts: String?
    @Persisted public var maximumCards: String?
    @Persisted public var countryFlag: String?
    @Persisted public var hasWallet: Int?
    @Persisted public var hasGroups: Int?
    @Persisted public var hasFloatingButton: Int?
    @Persisted public var hasDiscover: Int
    @Persisted public var useSmileSDK: String?
    @Persisted public var hasReferral: Int?
    @Persisted public var isManualKycRegistration: Int
    @Persisted public var countrySourceAddresses: String?
    @Persisted public var isDefault: Bool
    @Persisted public var successCallBackURL: String?
    @Persisted public var payerClientCode: String?
    @Persisted public var isSecureCardPayment: String?
    @Persisted public var failedCallBackURL: String?
    @Persisted public var webCheckoutURL: String?
    @Persisted public var clevertapAccountID: String?
    @Persisted public var clevertapToken: String?
    @Persisted public var showAssist: String?
    @Persisted public var mulaAssistInterestType: String?
    @Persisted public var mulaAssistDurationType: String?
    @Persisted public var mulaAssistInterestRate: String?
    @Persisted public var mulaAssistDuration: String?
    @Persisted public var mulaAssistLoanTermDuration: String?
    @Persisted public var accessKey: String?
    @Persisted public var checkoutServiceCode: String?
    @Persisted public var webHookURL: String?
    @Persisted public var fetchBearerTokenURL: String?
    @Persisted public var privacyPolicyURL: String?

    enum CodingKeys: String, CodingKey {
        case country = "COUNTRY"
        case countryCode = "COUNTRY_CODE"
        case countryURLNew = "COUNTRY_URL_NEW"
        case status = "STATUS"
        case currency = "CURRENCY"
        case mulaClientID = "MULA_CLIENT_ID"
        case countryMobileRegex = "COUNTRY_MOBILE_REGEX"
        case genericAccountNumberRegex = "GENERIC_ACCOUNT_NUMBER_REGEX"
        case extractSMSOnProfiling = "EXTRACT_SMS_ON_PROFILING"
        case countryCurrencyRegex = "COUNTRY_CURRENCY_REGEX"
        case excludedSMSSourceAddresses = "EXCLUDED_SMS_SOURCE_ADDRESSES"
        case countryDialCode = "COUNTRY_DIAL_CODE"
        case confirmedAccountLimits = "CONFIRMED_ACCOUNT_LIMITS"
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
        case hasDiscover = "HAS_DISCOVER"
        case useSmileSDK = "USE_SMILE_SDK"
        case hasReferral = "HAS_REFERRAL"
        case isManualKycRegistration = "IS_MANUAL_KYC_REGISTRATION"
        case countrySourceAddresses = "COUNTRY_SOURCE_ADDRESSES"
        case isDefault = "IS_DEFAULT"
        case successCallBackURL = "SUCCESS_CALL_BACK_URL"
        case payerClientCode = "PAYER_CLIENT_CODE"
        case isSecureCardPayment = "IS_SECURE_CARD_PAYMENT"
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

    init(country: String?, countryCode: String?, countryURLNew: String?, status: String?, currency: String?, mulaClientID: String?, countryMobileRegex: String?, genericAccountNumberRegex: String?, extractSMSOnProfiling: String?, countryCurrencyRegex: String?, excludedSMSSourceAddresses: String?, countryDialCode: String?, confirmedAccountLimits: String?, hotlineAppID: String?, hotlineAppKey: String?, freshchatAppID: String?, freshchatAppKey: String?, faqURL: String?, tacURL: String?, alphanumericRegexes: String?, minimumProfiledAccounts: String?, smsProfilingTimeout: String?, roundUpAmounts: String?, maximumCards: String?, countryFlag: String?, hasWallet: Int, hasGroups: Int, hasFloatingButton: Int, hasDiscover: Int, useSmileSDK: String?, hasReferral: Int, isManualKycRegistration: Int, countrySourceAddresses: String?, isDefault: Bool, successCallBackURL: String?, payerClientCode: String?, isSecureCardPayment: String?, failedCallBackURL: String?, webCheckoutURL: String?, clevertapAccountID: String?, clevertapToken: String?, showAssist: String?, mulaAssistInterestType: String?, mulaAssistDurationType: String?, mulaAssistInterestRate: String?, mulaAssistDuration: String?, mulaAssistLoanTermDuration: String?, accessKey: String?, checkoutServiceCode: String?, webHookURL: String?, fetchBearerTokenURL: String?, privacyPolicyURL: String?) {
        self.country = country
        self.countryCode = countryCode
        self.countryURLNew = countryURLNew
        self.status = status
        self.currency = currency
        self.mulaClientID = mulaClientID
        self.countryMobileRegex = countryMobileRegex
        self.genericAccountNumberRegex = genericAccountNumberRegex
        self.extractSMSOnProfiling = extractSMSOnProfiling
        self.countryCurrencyRegex = countryCurrencyRegex
        self.excludedSMSSourceAddresses = excludedSMSSourceAddresses
        self.countryDialCode = countryDialCode
        self.confirmedAccountLimits = confirmedAccountLimits
        self.hotlineAppID = hotlineAppID
        self.hotlineAppKey = hotlineAppKey
        self.freshchatAppID = freshchatAppID
        self.freshchatAppKey = freshchatAppKey
        self.faqURL = faqURL
        self.tacURL = tacURL
        self.alphanumericRegexes = alphanumericRegexes
        self.minimumProfiledAccounts = minimumProfiledAccounts
        self.smsProfilingTimeout = smsProfilingTimeout
        self.roundUpAmounts = roundUpAmounts
        self.maximumCards = maximumCards
        self.countryFlag = countryFlag
        self.hasWallet = hasWallet
        self.hasGroups = hasGroups
        self.hasFloatingButton = hasFloatingButton
        self.hasDiscover = hasDiscover
        self.useSmileSDK = useSmileSDK
        self.hasReferral = hasReferral
        self.isManualKycRegistration = isManualKycRegistration
        self.countrySourceAddresses = countrySourceAddresses
        self.isDefault = isDefault
        self.successCallBackURL = successCallBackURL
        self.payerClientCode = payerClientCode
        self.isSecureCardPayment = isSecureCardPayment
        self.failedCallBackURL = failedCallBackURL
        self.webCheckoutURL = webCheckoutURL
        self.clevertapAccountID = clevertapAccountID
        self.clevertapToken = clevertapToken
        self.showAssist = showAssist
        self.mulaAssistInterestType = mulaAssistInterestType
        self.mulaAssistDurationType = mulaAssistDurationType
        self.mulaAssistInterestRate = mulaAssistInterestRate
        self.mulaAssistDuration = mulaAssistDuration
        self.mulaAssistLoanTermDuration = mulaAssistLoanTermDuration
        self.accessKey = accessKey
        self.checkoutServiceCode = checkoutServiceCode
        self.webHookURL = webHookURL
        self.fetchBearerTokenURL = fetchBearerTokenURL
        self.privacyPolicyURL = privacyPolicyURL
    }
}
