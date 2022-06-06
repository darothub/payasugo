//
//  Enrollment.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation
import RealmSwift
// MARK: - Enrollment
public class Enrollment: EmbeddedObject,  ObjectKeyIdentifiable, Codable {
    @Persisted public var accountAlias:String?
    @Persisted public var accountNumber:String?
    @Persisted public var hubServiceID:String?
    @Persisted public var clientProfileAccountID: String?
    @Persisted public var isExplicit: String?
    @Persisted public var isContracted: Bool
    @Persisted public var dateLastRefreshed:String?
    @Persisted public var unknownMerchantID:String?
    @Persisted public var extraData:String?
    @Persisted public var accountStatus: String?
    @Persisted public var accountID: String?
    @Persisted public var isFetchingBill: Bool
    @Persisted public var confirmStatus: String?
    @Persisted public var merchantService: MerchantService?
    public static let IS_EXPLICIT = "Y"
    public static let NOT_EXPLICIT = "N"
    public static let UNCONFIRMED = "0"
    public static let ACCEPTED = "1"

    enum CodingKeys: String, CodingKey {
        case accountAlias = "ACCOUNT_ALIAS"
        case accountNumber = "ACCOUNT_NUMBER"
        case hubServiceID = "HUB_SERVICE_ID"
        case clientProfileAccountID
        case isExplicit = "IS_EXPLICIT"
        case isContracted = "IS_CONTRACTED"
        case dateLastRefreshed
        case unknownMerchantID = "UNKNOWN_MERCHANT_ID"
        case extraData
        case accountStatus = "ACCOUNT_STATUS"
        case accountID = "ACCOUNT_ID"
        case isFetchingBill, confirmStatus, merchantService
    }

    init( accountAlias: String?, accountNumber: String?, hubServiceID: String?, clientProfileAccountID: String?, isExplicit: String?, isContracted: Bool, dateLastRefreshed: String?, unknownMerchantID: String?, extraData: String?, accountStatus: String?, accountID: String?, isFetchingBill: Bool, confirmStatus: String?, merchantService: MerchantService?) {
        self.accountAlias = accountAlias
        self.accountNumber = accountNumber
        self.hubServiceID = hubServiceID
        self.clientProfileAccountID = clientProfileAccountID
        self.isExplicit = isExplicit
        self.isContracted = isContracted
        self.dateLastRefreshed = dateLastRefreshed
        self.unknownMerchantID = unknownMerchantID
        self.extraData = extraData
        self.accountStatus = accountStatus
        self.accountID = accountID
        self.isFetchingBill = isFetchingBill
        self.confirmStatus = confirmStatus
        self.merchantService = merchantService
    }
}
