//
//  File.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
import RealmSwift
public struct FSUAndPARDTO: Codable, BaseDTOprotocol {
    public let statusCode: Int
    public let statusMessage, activationKey: String
    public let profileInfo: [ProfileInfoDTO]
    public let services: [ServiceDTO]
    public let smsRegex: [SMSRegex]
    public let merchantPayers: [MerchantPayerDTO]
    public let categories: [CategoryDTO]
    public let contactInfo: [ContactInfoDTO]
    public let nominationInfo: [NominationInfoDTO]
    public let updateStatusCode: Int
    public let checksum, dateLastSynched: String
    public let mulaProfileInfo: MulaProfileInfo
    public let showcaseData: [ShowcaseDatum]
    public let transactionSummaryInfo: [TransactionSummaryInfoDTO]
    public let inviteMessage: String
    let invitesVisibility: Int
    public let defaultNetworkServiceID: Int?
    let manualBillsSetup: ManualBillsSetup
    let manualBillAccounts: [DynamicType]
    public let bundleData: [BundleDatum] 
    let bundleChecksum, bundleSyncDate: String
    public let countriesExtraInfo: CountriesExtraInfo
    public let securityQuestions: [SecurityQuestionDTO]
    public let cardDetails: [Card]
    let scanEnabled: Int
    let bannerData: [BannerDatum]
    let groupType: [DynamicType]
    let isInGroupWhitelist: Int
    public let virtualCards: [VirtualCard]
    let isTinggRetailEnabled, hasWallet, hasVirtualCard: Int
    let smilePartnerID: String
    let gasDetailsURL: String
    let gasOrderURL: String
    let cancelGasorderURL: String
    let iprsURL: String
    let iprsKey: String
    let gasRegionsURL, gasBrandsURL, gasProductsURL, gasPostOrderURL: String
    let discountImageURL: String
    let discountHeader, discountText: String
    let discountNoTimesShown, discountUserHasTransacted, tacVersion: Int
    let tacMessage: String
    let profileImageUploadAPI, britamAPIBaseEndpoint: String
    let britamAPIUser, britamAPIPass, britamAdMessage: String
    let britamShowAdCount: Int
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
        case defaultNetworkServiceID = "DEFAULT_NETWORK_SERVICE_ID"
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
        case groupType = "GROUP_TYPE"
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
struct BannerDatum: Codable {
    let activeStatus: Int
    let title, description: String
    let hasDeepLink, categoryID, serviceID: Int
    let imageURL: String
    let deepLink, dynamicLink: String
    let amount: String
    let priority: Int
    let actionName: String

    enum CodingKeys: String, CodingKey {
        case activeStatus = "ACTIVE_STATUS"
        case title = "TITLE"
        case description = "DESCRIPTION"
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



public enum StringOrIntEnum: Codable {
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
        throw DecodingError.typeMismatch(StringOrIntEnum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ActiveStatus"))
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
    public var toInt: Int {
        switch self {
        case .string(let value):
            if value.isEmpty {
                return 0
            }
            return value.convertStringToInt()
        case .integer(let value):
            return value
        }
    }
    public var toString: String {
        switch self {
        case .string(let value):
            return value
        case .integer(let value):
            return String(value)
        }
    }
}




// MARK: - ManualBillsSetup
struct ManualBillsSetup: Codable {
    let isManualBillEnabled, isMBillFloatingButtonEnabled: Int
    let paymentFrequencies: [PaymentFrequency]
    let manualBillServiceID, mnoProfilingService, genericProfilingService, minimumMbillAmount: Int
    let maximumMbillAmount: Int

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
struct PaymentFrequency: Codable {
    let frequency, value: String

    enum CodingKeys: String, CodingKey {
        case frequency = "FREQUENCY"
        case value = "VALUE"
    }
}

// MARK: - EXTProfileData
public struct EXTProfileData: Codable {
    public let nationalid: DynamicType
    public let hasBritamAccount: DynamicType

    enum CodingKeys: String, CodingKey {
        case nationalid = "NATIONALID"
        case hasBritamAccount = "HAS_BRITAM_ACCOUNT"
    }
}

// MARK: - PaymentOption
public struct PaymentOption: Codable {
    public let hubClientID: DynamicType
    public let clientName, clientCode: DynamicType
    public let isSelected: DynamicType

    enum CodingKeys: String, CodingKey {
        case hubClientID = "HUB_CLIENT_ID"
        case clientName = "CLIENT_NAME"
        case clientCode = "CLIENT_CODE"
        case isSelected = "IS_SELECTED"
    }
}

// MARK: - Wishlist
public struct Wishlist: Codable {
    public let name, referenceNo, paybill, paymentOptionID: DynamicType
    public let active, dateCreated, wishlistID: DynamicType

    enum CodingKeys: String, CodingKey {
        case name = "NAME"
        case referenceNo = "REFERENCE_NO"
        case paybill = "PAYBILL"
        case paymentOptionID = "PAYMENT_OPTION_ID"
        case active = "ACTIVE"
        case dateCreated = "DATE_CREATED"
        case wishlistID = "WISHLIST_ID"
    }
}

public enum IsExplicit: String, Codable {
    case n = "N"
    case y = "Y"
    
    public var bool: Bool {
        switch self {
        case .n: return false
        case .y: return true
        }
    }
}





enum BundleCategoryLabel: String, Codable {
    case category = "Category"
    case empty = ""
}

public enum BundleLabel: String, Codable {
    case bundle = "Bundle"
    case empty = ""
    case package = "Package"
}



enum FavoritesDisplayMode: String, Codable {
    case showAll = "SHOW_ALL"
}

enum PaymentLabel: String, Codable {
    case buy = "Buy"
    case pay = "Pay"
    case paymentLABELPay = "pay"
    case paymentLabelPay = "PAY"
    case topup = "Topup"
    case transfer = "Transfer"
}


enum Title: String, Codable {
    case alert = "Alert!"
    case inactiveService = "Inactive Service!"
}

// MARK: - ShowcaseDatum
public struct ShowcaseDatum: Codable {
    let title, description: String

    enum CodingKeys: String, CodingKey {
        case title = "TITLE"
        case description = "DESCRIPTION"
    }
}

// MARK: - SMSRegex
public struct SMSRegex: Codable {
    let serviceID: Int
    let serviceCode, regex, template: String
    let clientID: Int
    let sourceAddress, messageType, keywords, mappingValues: String
    let associativeSourceAddress, accountNumberRegex: String
    let countryID, parseType: Int
    let regexType: String
    let serviceCategoryID: Int
    let service, isContracted: String
    let accountSanitizerRegex: AccountSanitizerRegex
    let smsTemplateType: String

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
struct AccountSanitizerRegex: Codable {
    let hubserviceID, regex: String

    enum CodingKeys: String, CodingKey {
        case hubserviceID = "HUBSERVICE_ID"
        case regex = "REGEX"
    }
}

enum CurrencyCode: String, Codable {
    case kes = "KES"
}

enum Function: String, Codable {
    case post = "POST"
}

enum RequestOrigin: String, Codable {
    case mulaApp = "MULA_APP"
    case tinggCard = "TINGG_CARD"
}

enum ServiceCode: String, Codable {
    case dstvke = "DSTVKE"
    case jtldatabundles = "JTLDATABUNDLES"
    case safcom = "SAFCOM"
    case tinggWallet = "TINGG_WALLET"
    case tutukake = "TUTUKAKE"
}

enum ServiceName: String, Codable {
    case bolt = "Bolt"
    case dStv = "DStv"
    case jtlDataBundles = "JTL Data Bundles"
    case safaricom = "Safaricom"
    case tinggCardTopup = "Tingg Card Topup"
}

enum ShortDescription: String, Codable {
    case boltEUO2301271939TallinnEST = "BOLT.EU/O/2301271939 Tallinn EST"
    case paymentHasBeenAcceptedByTheMerchant = "Payment has been accepted by the merchant"
    case paymentHasBeenRejectedByTheMerchant = "Payment has been rejected by the merchant"
}

public enum Status: String, Codable {
    case failed = "failed"
    case success = "success"
}

public enum TransferType: String, Codable {
    case received = "Received"
    case sent = "Sent"
}

// MARK: - Encode/decode helpers

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



