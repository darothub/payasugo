//
//  Enrollment.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation

// MARK: - Enrollment
public class Enrollment: Identifiable, Codable {
    let accountAlias, accountNumber, hubServiceID, clientProfileAccountID: String?
    let isExplicit: String?
    let isContracted: Bool
    let dateLastRefreshed, unknownMerchantID, extraData, accountStatus: String?
    let accountID: String?
    let isFetchingBill: Bool
    let confirmStatus: String?
    let merchantService: MerchantService?
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
