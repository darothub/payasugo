//
//  Profile.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation

public class Profile : Identifiable, Encodable {
    public let id: Int = 0
    public let msisdn: String? = nil
    public let firstName: String? = nil
    public let lastName: String? = nil
    public let email: String? = nil
    public let picturePath: String? = nil
    public let accountId: String? = nil
    public let accountAlias: String? = nil
    public let accountNumber: String? = nil
    public let profileId: String? = nil
    public let currency: String? = nil
    public let currencyCode: String? = nil
    public let rewardAmount: String? = nil
    public let mulaAccount: String? = nil
    public let currencyNumber: String? = nil
    public let pinOption: String? = nil
    public let pinSet: String? = nil
    public let main: String? = nil
    public let simSerialNumber: String? = nil
    public let hasValidatedCard: String? = nil
    public let creditLimit: String? = nil
    public let hasActivatedAssist: String? = nil
    public let hasOptedOut: String? = nil
    public let currentUsage: String? = nil
    public let loanBalance: String? = nil
    public let hasActivatedWallet: String? = nil
    public let walletAccountId: String? = nil
    public let walletAccountNumber: String? = nil
    public let walletBalance: String? = nil
    public let freshchatRegistrationId: String? = nil
    public let loyaltyPoints: String? = nil
    public let identity: String? = ""
    public let postalAddress: String? = nil
    public let acceptedTacVersion: String? = nil
    public let dateAcceptedTac: String? = nil
    public let nationalId: String? = nil
    public let hasBritamAccount: String? = nil
    public let britamWalletData: String? = nil
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
