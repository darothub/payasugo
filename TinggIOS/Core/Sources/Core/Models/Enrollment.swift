//
//  Enrollment.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - Enrollment
public class Enrollment: Object,  ObjectKeyIdentifiable, Codable {
//    @Persisted public var accountAlias: String? = ""
//    @Persisted public var accountNumber: String? = ""
//    @Persisted public var hubServiceID: String? = ""
//    @Persisted public var clientProfileAccountID: String? = ""
//    @Persisted public var isExplicit: String? = ""
//    @Persisted public var isContracted: Bool = false
//    @Persisted public var dateLastRefreshed: String? = ""
//    @Persisted public var unknownMerchantID: String? = ""
//    @Persisted public var extraData: String? = ""
//    @Persisted public var accountStatus: String? = ""
//    @Persisted public var accountID: String? = ""
//    @Persisted public var isFetchingBill: Bool
//    @Persisted public var confirmStatus: String? = ""
//    @Persisted public var merchantService: MerchantService? = nil
//    public static let IS_EXPLICIT = "Y"
//    public static let NOT_EXPLICIT = "N"
//    public static let UNCONFIRMED = "0"
//    public static let ACCEPTED = "1"
    @Persisted public var merchantName: String?
    @Persisted(primaryKey: true) public var merchantID: Int?
    @Persisted public var merchantCode: String?
    @Persisted public var serviceName: String?
    @Persisted public var hubServiceID: Int?
    @Persisted public var serviceCode: String?
    @Persisted public var accountNumber: String?
    @Persisted public var accountName: String?
    @Persisted public var accountAlias: String?
    @Persisted public var accountID: String?
    @Persisted public var clientProfileAccountID: Int?
    @Persisted public var isExplicit: String?
//    public var extraData: JSONNull?
    @Persisted public var serviceCategoryID: String?
    @Persisted public var isReminder: String?
    @Persisted public var serviceLogo: String?
    @Persisted public var isProfiled: String?
    @Persisted public var isPartialAccount: String
    @Persisted public var unknownMerchantID: String?
    @Persisted public var merchantStatus: Int?
    @Persisted public var isContracted: String?
    @Persisted public var accountStatus: Int
    enum CodingKeys: String, CodingKey {
        case merchantName = "MERCHANT_NAME"
        case merchantID = "MERCHANT_ID"
        case merchantCode = "MERCHANT_CODE"
        case serviceName = "SERVICE_NAME"
        case hubServiceID = "HUB_SERVICE_ID"
        case serviceCode = "SERVICE_CODE"
        case accountNumber = "ACCOUNT_NUMBER"
        case accountName = "ACCOUNT_NAME"
        case accountAlias = "ACCOUNT_ALIAS"
        case accountID = "ACCOUNT_ID"
        case clientProfileAccountID
        case isExplicit = "IS_EXPLICIT"
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
