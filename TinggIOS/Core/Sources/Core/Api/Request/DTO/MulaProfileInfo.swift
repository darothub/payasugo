//
//  MulaProfileInfo.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation
// MARK: - MulaProfileInfo
public struct MulaProfileInfo: Codable {
    public  let mulaProfile: [MulaProfile]
    public let paymentOptions: [PaymentOption]
    public let wishlist: [Wishlist]
//    public let extProfileData: EXTProfileData

    enum CodingKeys: String, CodingKey {
        case mulaProfile = "MULA_PROFILE"
        case paymentOptions = "PAYMENT_OPTIONS"
        case wishlist = "WISHLIST"
//        case extProfileData = "EXT_PROFILE_DATA"
    }
}



// MARK: - MulaProfile
public struct MulaProfile: Codable {
    public let profileID: String?
    public let msisdn, firstName, lastName, emailAddress: String
    public let postalAddress, photoURL: String?
    public let hasValidatedCard, simSerialNumber: DynamicType?
    public let isMain: DynamicType?
    public let pinRequestType, isMulaPinSet, freshchatRestorationID, acceptedTacVersion: DynamicType?
    public let dateAcceptedTac: DynamicType?
    public let creditLimit, hasOptedOut, hasActivatedAssist: DynamicType?
    public let currentUsage, loanBalance: DynamicType?
    public let identity, walletAccountID, walletAccountNumber, hasActivatedWallet: DynamicType?
    public let walletBalance: DynamicType

    enum CodingKeys: String, CodingKey {
        case profileID = "PROFILE_ID"
        case msisdn = "MSISDN"
        case firstName = "FIRST_NAME"
        case lastName = "LAST_NAME"
        case emailAddress = "EMAIL_ADDRESS"
        case photoURL = "PHOTO_URL"
        case postalAddress = "POSTAL_ADDRESS"
        case hasValidatedCard = "HAS_VALIDATED_CARD"
        case simSerialNumber = "SIM_SERIAL_NUMBER"
        case isMain = "IS_MAIN"
        case pinRequestType = "PIN_REQUEST_TYPE"
        case isMulaPinSet = "IS_MULA_PIN_SET"
        case freshchatRestorationID = "FRESHCHAT_RESTORATION_ID"
        case acceptedTacVersion = "ACCEPTED_TAC_VERSION"
        case dateAcceptedTac = "DATE_ACCEPTED_TAC"
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
    public var toEntity: Profile {
        var entity = Profile()
        entity.profileID = self.profileID
        entity.msisdn = self.msisdn
        entity.firstName = self.firstName
        entity.lastName = self.lastName
        entity.emailAddress = self.emailAddress
        entity.photoURL = self.photoURL
        entity.postalAddress = self.postalAddress
        entity.hasValidatedCard = ((self.hasValidatedCard?.toBool) != nil)
        entity.simSerialNumber = self.simSerialNumber?.toString
        entity.isMain = ((self.isMain?.toBool) != nil)
        entity.pinRequestType = self.pinRequestType?.toString
        entity.isMulaPinSet = ((self.isMulaPinSet?.toBool) != nil)
        entity.freshchatRestorationID = self.freshchatRestorationID?.toString
        entity.acceptedTacVersion = self.acceptedTacVersion?.toInt
        entity.dateAcceptedTac = self.dateAcceptedTac?.toString
        entity.creditLimit = self.creditLimit?.toString
        entity.hasOptedOut = self.hasOptedOut?.toString
        entity.hasActivatedAssist = ((self.hasActivatedAssist?.toBool) != nil)
        entity.currentUsage = self.currentUsage?.toString ?? ""
        entity.loanBalance = self.loanBalance?.toString ?? ""
        entity.identity = self.identity?.toString
        entity.walletAccountID = self.walletAccountID?.toString
        entity.walletAccountNumber = self.walletAccountNumber?.toString
        entity.hasActivatedWallet = ((self.hasActivatedWallet?.toBool) != nil)
        entity.walletBalance = self.walletBalance.toString
        return entity
        
    }
}
