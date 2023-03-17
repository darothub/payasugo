//
//  NominationInfoDTO.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation
// MARK: - NominationInfo
public struct NominationInfoDTO: Codable {
    public let merchantName: DynamicType
    public let merchantID: DynamicType
    public let merchantCode: DynamicType
    public let serviceName: DynamicType
    public let hubServiceID: StringOrIntEnum
    public let serviceCode, accountNumber: DynamicType
    public let accountName, accountAlias: DynamicType?
    public let accountID: DynamicType?
    public let clientProfileAccountID: StringOrIntEnum?
    public let isExplicit: IsExplicit
    public let extraData: DynamicType?
    public let serviceCategoryID: StringOrIntEnum
    public var isReminder: DynamicType
    public let serviceLogo: String?
    public let isProfiled, isPartialAccount: DynamicType
    public let unknownMerchantID: DynamicType?
    public let merchantStatus: DynamicType
    public let isContracted: DynamicType
    public let accountStatus: StringOrIntEnum

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
        case extraData
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
    public var toEntity: Enrollment {
        let entity = Enrollment()
        entity.merchantName = self.merchantName.toString
        entity.merchantID = self.merchantID.toInt
        entity.merchantCode = self.merchantCode.toString
        entity.serviceName = self.serviceName.toString
        entity.hubServiceID = self.hubServiceID.toInt
        entity.serviceCode = self.serviceCode.toString
        entity.accountNumber = self.accountNumber.toString
        entity.accountName = self.accountName?.toString
        entity.accountAlias = self.accountAlias?.toString
        entity.accountID = self.accountID?.toString
        entity.clientProfileAccountID = self.clientProfileAccountID?.toInt ?? 0
        entity.isExplicit = self.isExplicit.bool
        entity.extraData = self.extraData.rawValue
        entity.serviceCategoryID = self.serviceCategoryID.toString
        entity.isReminder = self.isReminder.toBool
        entity.serviceLogo = self.serviceLogo
        entity.isProfiled = self.isProfiled.toBool
        entity.isPartialAccount = self.isPartialAccount.toBool
        entity.unknownMerchantID = self.unknownMerchantID?.toString
        entity.merchantStatus = self.merchantStatus.toInt
        entity.isContracted = self.isContracted.toBool
        entity.accountStatus = self.accountStatus.toInt
        return entity
        
    }
    public var isActive: Bool {
        self.accountStatus.toInt == 1
    }
}

