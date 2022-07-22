//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/07/2022.
//
// swiftlint:disable all

import Core
// MARK: - ParResponse
public struct PARAndFSUDTO: Codable, BaseDTOprotocol {
    public var statusCode: Int
    public var statusMessage, activationKey: String
    public var profileInfo: [Profile]
    public var services: [MerchantService]
    public var smsRegex: [SMSRegex]
    public var merchantPayers: [MerchantPayer]
    public var categories: [Category]
    public var contactInfo: [Contact]
    public var nominationInfo: [NominationInfo]
    public var updateStatusCode: Int
    public var checksum, dateLastSynched: String
    public var mulaProfileInfo: MulaProfileInfo
    public var showcaseData: [ShowcaseDatum]
    public var transactionSummaryInfo: [[String: String?]]
    public var inviteMessage: String
    public var invitesVisibility: Int
//    public var defaultNetworkServiceID: JSONNull?
    public var manualBillsSetup: ManualBillsSetup
    public var manualBillAccounts: [ManualBill]
    public var bundleData: [BundleDatum]
    public var bundleChecksum, bundleSyncDate: String
    public var countriesExtraInfo: CountriesExtraInfo
    public var securityQuestions: [SecurityQuestion]
    public var cardDetails: [Card]
    public var scanEnabled: Int
    public var bannerData: [BannerDatum]
//    public var groupType: [JSONAny]
    public var isInGroupWhitelist: Int
    public var virtualCards: [VirtualCard]
    public var isTinggRetailEnabled, hasWallet, hasVirtualCard: Int
    public var smilePartnerID: String
    public var gasDetailsURL: String
    public var gasOrderURL: String
    public var cancelGasorderURL: String
    public var iprsURL: String
    public var iprsKey: String
    public var gasRegionsURL, gasBrandsURL, gasProductsURL, gasPostOrderURL: String
    public var discountImageURL: String
    public var discountHeader, discountText: String
    public var discountNoTimesShown, discountUserHasTransacted, tacVersion: Int
    public var tacMessage: String
    public var profileImageUploadAPI, britamAPIBaseEndpoint: String
    public var britamAPIUser, britamAPIPass, britamAdMessage: String
    public var britamShowAdCount: Int

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case activationKey = "ACTIVATION_KEY"
        case profileInfo = "PROFILE_INFO"
        case services = "SERVICES"
        case smsRegex = "SMS_REGEX"
        case merchantPayers = "MERCHANT_PAYERS"
        case categories = "CATEGORIES"
        case contactInfo = "CONTACT_INFO"
        case nominationInfo = "NOMINATION_INFO"
        case updateStatusCode = "UPDATE_STATUS_CODE"
        case checksum = "CHECKSUM"
        case dateLastSynched = "DATE_LAST_SYNCHED"
        case mulaProfileInfo = "MULA_PROFILE_INFO"
        case showcaseData = "SHOWCASE_DATA"
        case transactionSummaryInfo = "TRANSACTION_SUMMARY_INFO"
        case inviteMessage = "INVITE_MESSAGE"
        case invitesVisibility = "INVITES_VISIBILITY"
//        case defaultNetworkServiceID = "DEFAULT_NETWORK_SERVICE_ID"
        case manualBillsSetup = "MANUAL_BILLS_SETUP"
        case manualBillAccounts = "MANUAL_BILL_ACCOUNTS"
        case bundleData = "BUNDLE_DATA"
        case bundleChecksum = "BUNDLE_CHECKSUM"
        case bundleSyncDate = "BUNDLE_SYNC_DATE"
        case countriesExtraInfo = "COUNTRIES_EXTRA_INFO"
        case securityQuestions = "SECURITY_QUESTIONS"
        case cardDetails = "CARD_DETAILS"
        case scanEnabled = "SCAN_ENABLED"
        case bannerData = "BANNER_DATA"
//        case groupType = "GROUP_TYPE"
        case isInGroupWhitelist = "IS_IN_GROUP_WHITELIST"
        case virtualCards = "VIRTUAL_CARDS"
        case isTinggRetailEnabled = "IS_TINGG_RETAIL_ENABLED"
        case hasWallet = "HAS_WALLET"
        case hasVirtualCard = "HAS_VIRTUAL_CARD"
        case smilePartnerID = "SMILE_PARTNER_ID"
        case gasDetailsURL = "GAS_DETAILS_URL"
        case gasOrderURL = "GAS_ORDER_URL"
        case cancelGasorderURL = "CANCEL_GASORDER_URL"
        case iprsURL = "IPRS_URL"
        case iprsKey = "IPRS_KEY"
        case gasRegionsURL = "GAS_REGIONS_URL"
        case gasBrandsURL = "GAS_BRANDS_URL"
        case gasProductsURL = "GAS_PRODUCTS_URL"
        case gasPostOrderURL = "GAS_POST_ORDER_URL"
        case discountImageURL = "DISCOUNT_IMAGE_URL"
        case discountHeader = "DISCOUNT_HEADER"
        case discountText = "DISCOUNT_TEXT"
        case discountNoTimesShown = "DISCOUNT_NO_TIMES_SHOWN"
        case discountUserHasTransacted = "DISCOUNT_USER_HAS_TRANSACTED"
        case tacVersion = "TAC_VERSION"
        case tacMessage = "TAC_MESSAGE"
        case profileImageUploadAPI = "PROFILE_IMAGE_UPLOAD_API"
        case britamAPIBaseEndpoint = "BRITAM_API_BASE_ENDPOINT"
        case britamAPIUser = "BRITAM_API_USER"
        case britamAPIPass = "BRITAM_API_PASS"
        case britamAdMessage = "BRITAM_AD_MESSAGE"
        case britamShowAdCount = "BRITAM_SHOW_AD_COUNT"
    }
}

// MARK: - BannerDatum
public struct BannerDatum: Codable {
    public var activeStatus: Int
    public var title, bannerDatumDescription: String
    public var hasDeepLink, categoryID, serviceID: Int
    public var imageURL: String
    public var deepLink, dynamicLink: String
    public var amount: String
    public var priority: Int
    public var actionName: String

    enum CodingKeys: String, CodingKey {
        case activeStatus = "ACTIVE_STATUS"
        case title = "TITLE"
        case bannerDatumDescription = "DESCRIPTION"
        case hasDeepLink = "HAS_DEEP_LINK"
        case categoryID = "CATEGORY_ID"
        case serviceID = "SERVICE_ID"
        case imageURL = "IMAGE_URL"
        case deepLink = "DEEP_LINK"
        case dynamicLink = "DYNAMIC_LINK"
        case amount = "AMOUNT"
        case priority = "PRIORITY"
        case actionName = "ACTION_NAME"
    }
}

// MARK: - BundleDatum
public struct BundleDatum: Codable {
    public var bundleCategoryID: Int
    public var categoryName: String
    public var position, serviceID: Int
    public var bundles: [Bundle]

    enum CodingKeys: String, CodingKey {
        case bundleCategoryID = "BUNDLE_CATEGORY_ID"
        case categoryName = "CATEGORY_NAME"
        case position = "POSITION"
        case serviceID = "SERVICE_ID"
        case bundles = "BUNDLES"
    }
}

// MARK: - Bundle
public struct Bundle: Codable {
    public var bundleID: Int
    public var bundleName: String
    public var position: Int
    public var cost: ActiveStatus
    public var bundleCode: String?

    enum CodingKeys: String, CodingKey {
        case bundleID = "BUNDLE_ID"
        case bundleName = "BUNDLE_NAME"
        case position = "POSITION"
        case cost = "COST"
        case bundleCode = "BUNDLE_CODE"
    }
}

public enum ActiveStatus: Codable {
    case integer(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ActiveStatus.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ActiveStatus"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - CardDetail
public struct CardDetail: Codable {
    public var cardAlias, payerClientID, cardType, activeStatus: String

    enum CodingKeys: String, CodingKey {
        case cardAlias = "CARD_ALIAS"
        case payerClientID = "PAYER_CLIENT_ID"
        case cardType = "CARD_TYPE"
        case activeStatus = "ACTIVE_STATUS"
    }
}


// MARK: - ContactInfo
public struct ContactInfo: Codable {
    public var contactTitle, location, phone, address: String
    public var email: String
    public var twitter, facebook: String
    public var website: String
    public var link: String
    public var countryID: String

    enum CodingKeys: String, CodingKey {
        case contactTitle = "CONTACT_TITLE"
        case location = "LOCATION"
        case phone = "PHONE"
        case address = "ADDRESS"
        case email = "EMAIL"
        case twitter = "TWITTER"
        case facebook = "FACEBOOK"
        case website = "WEBSITE"
        case link = "LINK"
        case countryID = "COUNTRY_ID"
    }
}

// MARK: - CountriesExtraInfo
public struct CountriesExtraInfo: Codable {
    public var countryURLNew: String
    public var hotlineAppKey, hotlineAppID: String
    public var faqURL: String
    public var tacURL, privacyPolicyURL: String
    public var excludedSMSSourceAddresses, countryMobileRegex, genericAccountNumberRegex: String
    public var extractSMSOnProfiling: Int
    public var countryCurrencyRegex, countrySourceAddresses: String
    public var confirmedAccountLimits: Int
    public var alphanumericRegexes: String
    public var isDefault: Bool
    public var freshchatAppKey, freshchatAppID, minimumProfiledAccounts, smsProfilingTimeout: String
//    public var roundUpAmounts: RoundUpAmounts
    public var successCallBackURL: String
    public var payerClientCode, isSecureCardPayment: String
    public var failedCallBackURL, webCheckoutURL: String
    public var countryFlag: String
    public var maximumCards, clevertapAccountID, clevertapToken: String
    public var showAssist: Int
    public var mulaAssistInterestType, mulaAssistInterestRate, mulaAssistDurationType, mulaAssistLoanTermDuration: String
    public var hasWallet, hasGroups, hasFloatingButton, hasDiscover: Int
    public var useSmileSDK, hasReferral: Int
    public var fetchBearerTokenURL: String

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
//        case roundUpAmounts = "ROUND_UP_AMOUNTS"
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
    }
}

enum RoundUpAmounts: String, Codable {
    case no = "NO"
    case yes = "YES"
}

// MARK: - ManualBillAccount
public struct ManualBillAccount: Codable {
    public var manualBillID, billAmount, merchantAccountNumber, merchantName: String
    public var accountPayload, billDueDate, billReminderFrequency: String
    public var paymentOptions: [ManualBillAccountPaymentOption]
    public var categoryID: String
    public var isBillSearch: Int

    enum CodingKeys: String, CodingKey {
        case manualBillID = "MANUAL_BILL_ID"
        case billAmount = "BILL_AMOUNT"
        case merchantAccountNumber = "MERCHANT_ACCOUNT_NUMBER"
        case merchantName = "MERCHANT_NAME"
        case accountPayload
        case billDueDate = "BILL_DUE_DATE"
        case billReminderFrequency = "BILL_REMINDER_FREQUENCY"
        case paymentOptions = "PAYMENT_OPTIONS"
        case categoryID = "CATEGORY_ID"
        case isBillSearch = "IS_BILL_SEARCH"
    }
}

// MARK: - ManualBillAccountPaymentOption
public struct ManualBillAccountPaymentOption: Codable {
    let payerClientID, payerReference, referenceLabel: String

    enum CodingKeys: String, CodingKey {
        case payerClientID = "PAYER_CLIENT_ID"
        case payerReference = "PAYER_REFERENCE"
        case referenceLabel = "REFERENCE_LABEL"
    }
}

// MARK: - ManualBillsSetup
public struct ManualBillsSetup: Codable {
    public var isManualBillEnabled, isMBillFloatingButtonEnabled: Int
    public var paymentFrequencies: [PaymentFrequency]
    public var manualBillServiceID, mnoProfilingService, genericProfilingService, minimumMbillAmount: Int
    public var maximumMbillAmount: Int

    enum CodingKeys: String, CodingKey {
        case isManualBillEnabled = "IS_MANUAL_BILL_ENABLED"
        case isMBillFloatingButtonEnabled = "IS_M_BILL_FLOATING_BUTTON_ENABLED"
        case paymentFrequencies = "PAYMENT_FREQUENCIES"
        case manualBillServiceID = "MANUAL_BILL_SERVICE_ID"
        case mnoProfilingService = "MNO_PROFILING_SERVICE"
        case genericProfilingService = "GENERIC_PROFILING_SERVICE"
        case minimumMbillAmount = "MINIMUM_MBILL_AMOUNT"
        case maximumMbillAmount = "MAXIMUM_MBILL_AMOUNT"
    }
}

// MARK: - PaymentFrequency
public struct PaymentFrequency: Codable {
    let frequency, value: String

    enum CodingKeys: String, CodingKey {
        case frequency = "FREQUENCY"
        case value = "VALUE"
    }
}

//// MARK: - MerchantPayer
//struct MerchantPayer: Codable {
//    let hubClientID, clientName, clientCode, countryID: String
//    let country, activeStatus, canPay, viewable: String
//    let statusMessage: String
//    let logo: String
//    let webTemplateID: JSONNull?
//    let paybill, networkID, referenceLabel, isSelected: String
//    let paymentInstructions, isDefault, orderID, paymentInstruction: String
//    let abbreviation, colorCode, shortName, showLogo: String
//    let checkoutType, canPayForOther, payerReference, chargeSyncMode: String
//    let paymentCount: String
//    let isChargingPayer: RoundUpAmounts
//    let payerCharge, title, message, paymentActivationDesc: String
//
//    enum CodingKeys: String, CodingKey {
//        case hubClientID = "HUB_CLIENT_ID"
//        case clientName = "CLIENT_NAME"
//        case clientCode = "CLIENT_CODE"
//        case countryID = "COUNTRY_ID"
//        case country = "COUNTRY"
//        case activeStatus = "ACTIVE_STATUS"
//        case canPay = "CAN_PAY"
//        case viewable = "VIEWABLE"
//        case statusMessage = "STATUS_MESSAGE"
//        case logo = "LOGO"
//        case webTemplateID = "WEB_TEMPLATE_ID"
//        case paybill = "PAYBILL"
//        case networkID = "NETWORK_ID"
//        case referenceLabel = "REFERENCE_LABEL"
//        case isSelected = "IS_SELECTED"
//        case paymentInstructions = "PAYMENT_INSTRUCTIONS"
//        case isDefault = "IS_DEFAULT"
//        case orderID = "ORDER_ID"
//        case paymentInstruction = "PAYMENT_INSTRUCTION"
//        case abbreviation = "ABBREVIATION"
//        case colorCode = "COLOR_CODE"
//        case shortName = "SHORT_NAME"
//        case showLogo = "SHOW_LOGO"
//        case checkoutType = "CHECKOUT_TYPE"
//        case canPayForOther = "CAN_PAY_FOR_OTHER"
//        case payerReference = "PAYER_REFERENCE"
//        case chargeSyncMode = "CHARGE_SYNC_MODE"
//        case paymentCount = "PAYMENT_COUNT"
//        case isChargingPayer = "IS_CHARGING_PAYER"
//        case payerCharge = "PAYER_CHARGE"
//        case title = "TITLE"
//        case message = "MESSAGE"
//        case paymentActivationDesc = "PAYMENT_ACTIVATION_DESC"
//    }
//}

// MARK: - MulaProfileInfo
public struct MulaProfileInfo: Codable {
    public var mulaProfile: [MulaProfile]
    public var paymentOptions: [MulaProfileInfoPaymentOption]
    public var wishlist: [Wishlist]
    public var cardInfo: CardInfo
    public var extProfileData: EXTProfileData

    enum CodingKeys: String, CodingKey {
        case mulaProfile = "MULA_PROFILE"
        case paymentOptions = "PAYMENT_OPTIONS"
        case wishlist = "WISHLIST"
        case cardInfo = "CARD_INFO"
        case extProfileData = "EXT_PROFILE_DATA"
    }
}

// MARK: - CardInfo
public struct CardInfo: Codable {
    let the6522: The6522

    enum CodingKeys: String, CodingKey {
        case the6522 = "6522"
    }
}

// MARK: - The6522
public struct The6522: Codable {
    let retryAttempts: Int

    enum CodingKeys: String, CodingKey {
        case retryAttempts = "RETRY_ATTEMPTS"
    }
}

// MARK: - EXTProfileData
public struct EXTProfileData: Codable {
    public var nationalid: String
    public var hasBritamAccount: Int
    public var britamWalletData: [BritamWalletDatum]

    enum CodingKeys: String, CodingKey {
        case nationalid = "NATIONALID"
        case hasBritamAccount = "HAS_BRITAM_ACCOUNT"
        case britamWalletData = "BRITAM_WALLET_DATA"
    }
}

// MARK: - BritamWalletDatum
public struct BritamWalletDatum: Codable {
    let walletID, transactionID: Int

    enum CodingKeys: String, CodingKey {
        case walletID = "WALLET_ID"
        case transactionID = "TRANSACTION_ID"
    }
}

// MARK: - MulaProfile
public struct MulaProfile: Codable {
//    public var profileID: JSONNull?
    public var msisdn, firstName, lastName, emailAddress: String
    public var photoURL: String
    public var postalAddress: String
    public var hasValidatedCard: Int
//    public var simSerialNumber: JSONNull?
    public var isMain: Int
//    public var pinRequestType, isMulaPinSet, freshchatRestorationID, acceptedTacVersion: JSONNull?
//    public var dateAcceptedTac: JSONNull?
    public var creditLimit, hasOptedOut, hasActivatedAssist: String
    public var currentUsage, loanBalance: Int
    public var identity, walletAccountID, walletAccountNumber, hasActivatedWallet: String
    public var walletBalance: String

    enum CodingKeys: String, CodingKey {
//        case profileID = "PROFILE_ID"
        case msisdn = "MSISDN"
        case firstName = "FIRST_NAME"
        case lastName = "LAST_NAME"
        case emailAddress = "EMAIL_ADDRESS"
        case photoURL = "PHOTO_URL"
        case postalAddress = "POSTAL_ADDRESS"
        case hasValidatedCard = "HAS_VALIDATED_CARD"
//        case simSerialNumber = "SIM_SERIAL_NUMBER"
        case isMain = "IS_MAIN"
//        case pinRequestType = "PIN_REQUEST_TYPE"
//        case isMulaPinSet = "IS_MULA_PIN_SET"
//        case freshchatRestorationID = "FRESHCHAT_RESTORATION_ID"
//        case acceptedTacVersion = "ACCEPTED_TAC_VERSION"
//        case dateAcceptedTac = "DATE_ACCEPTED_TAC"
        case creditLimit = "CREDIT_LIMIT"
        case hasOptedOut = "HAS_OPTED_OUT"
        case hasActivatedAssist = "HAS_ACTIVATED_ASSIST"
        case currentUsage = "CURRENT_USAGE"
        case loanBalance = "LOAN_BALANCE"
        case identity = "IDENTITY"
        case walletAccountID = "WALLET_ACCOUNT_ID"
        case walletAccountNumber = "WALLET_ACCOUNT_NUMBER"
        case hasActivatedWallet = "HAS_ACTIVATED_WALLET"
        case walletBalance = "WALLET_BALANCE"
    }
}

// MARK: - MulaProfileInfoPaymentOption
public struct MulaProfileInfoPaymentOption: Codable {
    public var hubClientID, clientName, clientCode, isSelected: String
    public var paymentOptionID: Int

    enum CodingKeys: String, CodingKey {
        case hubClientID = "HUB_CLIENT_ID"
        case clientName = "CLIENT_NAME"
        case clientCode = "CLIENT_CODE"
        case isSelected = "IS_SELECTED"
        case paymentOptionID = "PAYMENT_OPTION_ID"
    }
}

// MARK: - Wishlist
public struct Wishlist: Codable {
    public var name: Name
    public var referenceNo, paybill, paymentOptionID: String
    public var active: ActiveStatus
//    public var dateCreated: DateCreated
    public var wishlistID: Int

    enum CodingKeys: String, CodingKey {
        case name = "NAME"
        case referenceNo = "REFERENCE_NO"
        case paybill = "PAYBILL"
        case paymentOptionID = "PAYMENT_OPTION_ID"
        case active = "ACTIVE"
//        case dateCreated = "DATE_CREATED"
        case wishlistID = "WISHLIST_ID"
    }
}

enum DateCreated: String, Codable {
    case the20170315042549 = "2017-03-15 04:25:49"
    case the20170426022705 = "2017-04-26 02:27:05"
    case the20170426052002 = "2017-04-26 05:20:02"
    case the20170426052006 = "2017-04-26 05:20:06"
}

public enum Name: String, Codable {
    case rent = "Rent"
}

// MARK: - NominationInfo
public struct NominationInfo: Codable {
    public var merchantName: String
    public var merchantID: Int?
//    public var merchantCode: MerchantCode?
    public var serviceName: String
    public var hubServiceID: Int
    public var serviceCode: String?
    public var accountNumber: String
    public var accountName, accountAlias: String?
//    public var accountID: JSONNull?
    public var clientProfileAccountID: Int?
//    public var isExplicit: IsExplicit
//    public var extraData: JSONNull?
    public var serviceCategoryID: ActiveStatus
    public var isReminder: String
    public var serviceLogo: String?
    public var isProfiled, isPartialAccount: String
    public var unknownMerchantID: String?
    public var merchantStatus: Int
    public var isContracted: String
    public var accountStatus: Int

    enum CodingKeys: String, CodingKey {
        case merchantName = "MERCHANT_NAME"
        case merchantID = "MERCHANT_ID"
//        case merchantCode = "MERCHANT_CODE"
        case serviceName = "SERVICE_NAME"
        case hubServiceID = "HUB_SERVICE_ID"
        case serviceCode = "SERVICE_CODE"
        case accountNumber = "ACCOUNT_NUMBER"
        case accountName = "ACCOUNT_NAME"
        case accountAlias = "ACCOUNT_ALIAS"
//        case accountID = "ACCOUNT_ID"
        case clientProfileAccountID
//        case isExplicit = "IS_EXPLICIT"
//        case extraData
        case serviceCategoryID = "SERVICE_CATEGORY_ID"
        case isReminder = "IS_REMINDER"
        case serviceLogo = "SERVICE_LOGO"
        case isProfiled = "IS_PROFILED"
        case isPartialAccount = "IS_PARTIAL_ACCOUNT"
        case unknownMerchantID = "UNKNOWN_MERCHANT_ID"
        case merchantStatus = "MERCHANT_STATUS"
        case isContracted = "IS_CONTRACTED"
        case accountStatus = "ACCOUNT_STATUS"
    }
}

enum IsExplicit: String, Codable {
    case n = "N"
    case y = "Y"
}

enum MerchantCode: String, Codable {
    case celke = "CELKE"
}

// MARK: - ProfileInfo
public struct ProfileInfo: Codable {
    public var profileID: Int
    public var firstName, lastName: String
    public var photoURL: String
    public var msisdn, emailAddress: String

    enum CodingKeys: String, CodingKey {
        case profileID = "PROFILE_ID"
        case firstName = "FIRST_NAME"
        case lastName = "LAST_NAME"
        case photoURL = "PHOTO_URL"
        case msisdn = "MSISDN"
        case emailAddress = "EMAIL_ADDRESS"
    }
}

//// MARK: - SecurityQuestion
//public struct SecurityQuestion: Codable {
//    let questionID, securityQuestion: String
//
//    enum CodingKeys: String, CodingKey {
//        case questionID = "QUESTION_ID"
//        case securityQuestion = "SECURITY_QUESTION"
//    }
//}

// MARK: - Service
public struct Service: Codable {
    public var serviceName, clientName, hubClientID, serviceCode: String
    public var hubServiceID, clientCode, minAmount, maxAmount: String
    public var servicePatternID, serviceAccountKey: String
//    public var exactPayment: ExactPayment
    public var categoryID: ActiveStatus
    public var activeStatus: String
    public var serviceLogo: String
    public var isPrepaidService, paybill, networkID, webTemplateID: String
    public var receiverSourceAddress, referenceLabel: String
//    public var presentmentType: PresentmentType
    public var referenceInputMask, formatErrorMessage: String
//    public var inputType: InputType
    public var colorCode: String
//    public var formType: FormType
//    public var formParameters: FORMPARAMETERSUnion
    public var abbreviation: String
//    public var paymentLabel: PaymentLabel
    public var orderID, regexType, isBundleService, ignoreSaveEnrollment: String
    public var hasBillAmount: String
//    public var serviceParameters: SERVICEPARAMETERSUnion
//    public var bundleLabel: BundleLabel
//    public var bundleCategoryLabel: BundleCategoryLabel
    public var displayNoPendingBillDialog, canEditAmount, isCyclicService, isDislayableOnLifestream: String
//    public var favoritesDisplayMode: FavoritesDisplayMode
//    public var isRefresh: RoundUpAmounts
//    public var applicableCharges: [JSONAny]
//    public var validateBillAmount: RoundUpAmounts
    public var charges: String
//    public var title: Title
    public var message: String

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
//        case exactPayment = "EXACT_PAYMENT"
        case categoryID = "CATEGORY_ID"
        case activeStatus = "ACTIVE_STATUS"
        case serviceLogo = "SERVICE_LOGO"
        case isPrepaidService = "IS_PREPAID_SERVICE"
        case paybill = "PAYBILL"
        case networkID = "NETWORK_ID"
        case webTemplateID = "WEB_TEMPLATE_ID"
        case receiverSourceAddress = "RECEIVER_SOURCE_ADDRESS"
        case referenceLabel = "REFERENCE_LABEL"
//        case presentmentType = "PRESENTMENT_TYPE"
        case referenceInputMask = "REFERENCE_INPUT_MASK"
        case formatErrorMessage = "FORMAT_ERROR_MESSAGE"
//        case inputType = "INPUT_TYPE"
        case colorCode = "COLOR_CODE"
//        case formType = "FORM_TYPE"
//        case formParameters = "FORM_PARAMETERS"
        case abbreviation = "ABBREVIATION"
//        case paymentLabel = "PAYMENT_LABEL"
        case orderID = "ORDER_ID"
        case regexType = "REGEX_TYPE"
        case isBundleService = "IS_BUNDLE_SERVICE"
        case ignoreSaveEnrollment = "IGNORE_SAVE_ENROLLMENT"
        case hasBillAmount = "HAS_BILL_AMOUNT"
//        case serviceParameters = "SERVICE_PARAMETERS"
//        case bundleLabel = "BUNDLE_LABEL"
//        case bundleCategoryLabel = "BUNDLE_CATEGORY_LABEL"
        case displayNoPendingBillDialog = "DISPLAY_NO_PENDING_BILL_DIALOG"
        case canEditAmount = "CAN_EDIT_AMOUNT"
        case isCyclicService = "IS_CYCLIC_SERVICE"
        case isDislayableOnLifestream = "IS_DISLAYABLE_ON_LIFESTREAM"
//        case favoritesDisplayMode = "FAVORITES_DISPLAY_MODE"
//        case isRefresh = "IS_REFRESH"
//        case applicableCharges = "APPLICABLE_CHARGES"
//        case validateBillAmount = "VALIDATE_BILL_AMOUNT"
        case charges = "CHARGES"
//        case title = "TITLE"
        case message = "MESSAGE"
    }
}

enum BundleCategoryLabel: String, Codable {
    case category = "Category"
    case empty = ""
}

enum BundleLabel: String, Codable {
    case bundle = "Bundle"
    case empty = ""
    case package = "Package"
}

enum ExactPayment: String, Codable {
    case no = "no"
    case yes = "yes"
}

enum FavoritesDisplayMode: String, Codable {
    case showAll = "SHOW_ALL"
}

enum FORMPARAMETERSUnion: Codable {
    case formparametersClass(FORMPARAMETERSClass)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(FORMPARAMETERSClass.self) {
            self = .formparametersClass(x)
            return
        }
        throw DecodingError.typeMismatch(FORMPARAMETERSUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for FORMPARAMETERSUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .formparametersClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - FORMPARAMETERSClass
public struct FORMPARAMETERSClass: Codable {
    public var formParameters: [FormParameter]
    public var name, label: String?

    enum CodingKeys: String, CodingKey {
        case formParameters = "FORM_PARAMETERS"
        case name = "NAME"
        case label = "LABEL"
    }
}

// MARK: - FormParameter
public struct FormParameter: Codable {
    public var itemName, displayName, itemType, isReferenceField: String?
    public var keyValueData, name: String?
    public var items: [Item]?

    enum CodingKeys: String, CodingKey {
        case itemName = "ITEM_NAME"
        case displayName = "DISPLAY_NAME"
        case itemType = "ITEM_TYPE"
        case isReferenceField = "IS_REFERENCE_FIELD"
        case keyValueData = "KEY_VALUE_DATA"
        case name = "NAME"
        case items = "ITEMS"
    }
}

// MARK: - Item
public struct Item: Codable {
    public var itemID: Int
    public var name: String
    public var amount: Int

    enum CodingKeys: String, CodingKey {
        case itemID = "ITEM_ID"
        case name = "NAME"
        case amount = "AMOUNT"
    }
}

enum FormType: String, Codable {
    case dynamicForm = "DYNAMIC_FORM"
    case genericForm = "GENERIC_FORM"
    case staticForm = "STATIC_FORM"
}

enum InputType: String, Codable {
    case empty = ""
    case numeric = "numeric"
    case phone = "phone"
    case text = "text"
}

enum PaymentLabel: String, Codable {
    case buy = "Buy"
    case pay = "Pay"
    case paymentLabelPay = "PAY"
    case topup = "Topup"
    case transfer = "Transfer"
}

enum PresentmentType: String, Codable {
    case empty = ""
    case hasNone = "hasNone"
    case hasPostpaid = "hasPostpaid"
    case hasPresentment = "hasPresentment"
    case hasValidation = "hasValidation"
}

enum SERVICEPARAMETERSUnion: Codable {
    case serviceparametersClass(SERVICEPARAMETERSClass)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(SERVICEPARAMETERSClass.self) {
            self = .serviceparametersClass(x)
            return
        }
        throw DecodingError.typeMismatch(SERVICEPARAMETERSUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SERVICEPARAMETERSUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .serviceparametersClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - SERVICEPARAMETERSClass
public struct SERVICEPARAMETERSClass: Codable {
    public var servicesData: [ServicesDatum]

    enum CodingKeys: String, CodingKey {
        case servicesData = "SERVICES_DATA"
    }
}

// MARK: - ServicesDatum
public struct ServicesDatum: Codable {
    let serviceID: Int
    let serviceName: String

    enum CodingKeys: String, CodingKey {
        case serviceID = "SERVICE_ID"
        case serviceName = "SERVICE_NAME"
    }
}

enum Title: String, Codable {
    case alert = "Alert!"
    case inactiveService = "Inactive Service!"
}

// MARK: - ShowcaseDatum
public struct ShowcaseDatum: Codable {
    public var title, showcaseDatumDescription: String

    enum CodingKeys: String, CodingKey {
        case title = "TITLE"
        case showcaseDatumDescription = "DESCRIPTION"
    }
}

// MARK: - SMSRegex
public struct SMSRegex: Codable {
    public var serviceID: Int
    public var serviceCode, regex, template: String
    public var clientID: Int
    public var sourceAddress, messageType, keywords, mappingValues: String
    public var associativeSourceAddress, accountNumberRegex: String
    public var countryID, parseType: Int
    public var regexType: String
    public var serviceCategoryID: Int
    public var service, isContracted: String
    public var accountSanitizerRegex: AccountSanitizerRegex
    public var smsTemplateType: String

    enum CodingKeys: String, CodingKey {
        case serviceID = "SERVICE_ID"
        case serviceCode = "SERVICE_CODE"
        case regex = "REGEX"
        case template = "TEMPLATE"
        case clientID = "CLIENT_ID"
        case sourceAddress = "SOURCE_ADDRESS"
        case messageType = "MESSAGE_TYPE"
        case keywords = "KEYWORDS"
        case mappingValues = "MAPPING_VALUES"
        case associativeSourceAddress = "ASSOCIATIVE_SOURCE_ADDRESS"
        case accountNumberRegex = "ACCOUNT_NUMBER_REGEX"
        case countryID = "COUNTRY_ID"
        case parseType = "PARSE_TYPE"
        case regexType = "REGEX_TYPE"
        case serviceCategoryID = "SERVICE_CATEGORY_ID"
        case service = "SERVICE"
        case isContracted = "IS_CONTRACTED"
        case accountSanitizerRegex = "ACCOUNT_SANITIZER_REGEX"
        case smsTemplateType = "SMS_TEMPLATE_TYPE"
    }
}

// MARK: - AccountSanitizerRegex
public struct AccountSanitizerRegex: Codable {
    public var hubserviceID, regex: String

    enum CodingKeys: String, CodingKey {
        case hubserviceID = "HUBSERVICE_ID"
        case regex = "REGEX"
    }
}

// MARK: - VirtualCard
public struct VirtualCard: Codable {
    let cardAlias, activeStatus: String

    enum CodingKeys: String, CodingKey {
        case cardAlias = "CARD_ALIAS"
        case activeStatus = "ACTIVE_STATUS"
    }
}

//// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
