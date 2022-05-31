//
//  Profile.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation

public class Profile : Identifiable, Encodable {
    public var id: Int = 0
    public var msisdn: String? = nil
    public var firstName: String? = nil
    public var lastName: String? = nil
    public var email: String? = nil
    public var picturePath: String? = nil
    public var accountId: String? = nil
    public var accountAlias: String? = nil
    public var accountNumber: String? = nil
    public var profileId: String? = nil
    public var currency: String? = nil
    public var currencyCode: String? = nil
    public var rewardAmount: String? = nil
    public var mulaAccount: String? = nil
    public var currencyNumber: String? = nil
    public var pinOption: String? = nil
    public var pinSet: String? = nil
    public var main: String? = nil
    public var simSerialNumber: String? = nil
    public var hasValidatedCard: String? = nil
    public var creditLimit: String? = nil
    public var hasActivatedAssist: String? = nil
    public var hasOptedOut: String? = nil
    public var currentUsage: String? = nil
    public var loanBalance: String? = nil
    public var hasActivatedWallet: String? = nil
    public var walletAccountId: String? = nil
    public var walletAccountNumber: String? = nil
    public var walletBalance: String? = nil
    public var freshchatRegistrationId: String? = nil
    public var loyaltyPoints: String? = nil
    public var identity: String? = ""
    public var postalAddress: String? = nil
    public var acceptedTacVersion: String? = nil
    public var dateAcceptedTac: String? = nil
    public var nationalId: String? = nil
    public var hasBritamAccount: String? = nil
    public var britamWalletData: String? = nil
    enum CodingKeys: String, CodingKey {
        case id = "PROFILE_ID"
        case msisdn = "MSISDN"
        case firstName = "FIRST_NAME"
        case lastName = "LAST_NAME"
        case email = "EMAIL_ADDRESS"
        case picturePath = "PHOTO_URL"
        case pinOption = "PIN_REQUEST_TYPE"
        case pinSet = "IS_MULA_PIN_SET"
        case main = "IS_MAIN"
        case simSerialNumber = "SIM_SERIAL_NUMBER"
        case hasValidatedCard = "HAS_VALIDATED_CARD"
        case creditLimit = "CREDIT_LIMIT"
        case hasActivatedAssist = "HAS_ACTIVATED_ASSIST"
        case hasOptedOut = "HAS_OPTED_OUT"
        case currentUsage = "CURRENT_USAGE"
        case loanBalance = "LOAN_BALANCE"
        case hasActivatedWallet = "HAS_ACTIVATED_WALLET"
        case walletAccountId = "WALLET_ACCOUNT_ID"
        case walletAccountNumber = "WALLET_ACCOUNT_NUMBER"
        case walletBalance = "WALLET_BALANCE"
        case freshchatRegistrationId = "FRESHCHAT_RESTORATION_ID"
        case loyaltyPoints = "LOYALTY_POINTS"
        case identity = "IDENTITY"
        case postalAddress = "POSTAL_ADDRESS"
        case acceptedTacVersion = "ACCEPTED_TAC_VERSION"
        case dateAcceptedTac = "DATE_ACCEPTED_TAC"
        case nationalId =  "NATIONALID"
        case hasBritamAccount = "HAS_BRITAM_ACCOUNT"
        case britamWalletData = "BRITAM_WALLET_DATA"
        
    }
}
