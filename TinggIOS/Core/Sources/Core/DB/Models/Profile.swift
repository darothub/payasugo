//
//  Profile.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift

// MARK: - Profile
public class Profile: Object, DBObject,  ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var profileID: String? = ""
    @Persisted public var msisdn: String? = ""
    @Persisted public var firstName: String? = ""
    @Persisted public var lastName: String? = ""
    @Persisted public var emailAddress: String? = ""
    @Persisted public var photoURL: String? = ""
    @Persisted public var accountID: String? = ""
    @Persisted public var accountAlias: String? = ""
    @Persisted public var accountNumber: String? = ""
    @Persisted public var profileProfileID: String? = ""
    @Persisted public var currency: String? = ""
    @Persisted public var currencyCode: String? = ""
    @Persisted public var rewardAmount: String? = ""
    @Persisted public var mulaAccount: String? = ""
    @Persisted public var currencyNumber: String? = ""
    @Persisted public var pinRequestType: String? = ""
    @Persisted public var isMulaPinSet: Bool = false
    @Persisted public var isMain: Bool = false
    @Persisted public var simSerialNumber: String? = ""
    @Persisted public var hasValidatedCard: Bool = false
    @Persisted public var creditLimit: String? = ""
    @Persisted public var hasActivatedAssist: Bool = false
    @Persisted public var hasOptedOut: String? = ""
    @Persisted public var currentUsage: String = "0"
    @Persisted public var loanBalance: String = "0"
    @Persisted public var hasActivatedWallet: Bool = false
    @Persisted public var walletAccountID: String? = ""
    @Persisted public var walletAccountNumber: String? = ""
    @Persisted public var walletBalance: String? = ""
    @Persisted public var freshchatRestorationID: String? = ""
    @Persisted public var loyaltyPoints: String? = ""
    @Persisted public var identity: String? = ""
    @Persisted public var postalAddress: String? = ""
    @Persisted public var acceptedTacVersion: Int?
    @Persisted public var dateAcceptedTac: String? = ""
    @Persisted public var nationalid: String? = ""
    @Persisted public var hasBritamAccount: String? = ""
    @Persisted public var britamWalletData: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case profileID = "PROFILE_ID"
        case msisdn = "MSISDN"
        case firstName = "FIRST_NAME"
        case lastName = "LAST_NAME"
        case emailAddress = "EMAIL_ADDRESS"
        case photoURL = "PHOTO_URL"
        case accountID = "accountId"
        case accountAlias, accountNumber
        case profileProfileID = "profileId"
        case currency, currencyCode, rewardAmount, mulaAccount, currencyNumber
        case pinRequestType = "PIN_REQUEST_TYPE"
        case isMulaPinSet = "IS_MULA_PIN_SET"
        case isMain = "IS_MAIN"
        case simSerialNumber = "SIM_SERIAL_NUMBER"
        case hasValidatedCard = "HAS_VALIDATED_CARD"
        case creditLimit = "CREDIT_LIMIT"
        case hasActivatedAssist = "HAS_ACTIVATED_ASSIST"
        case hasOptedOut = "HAS_OPTED_OUT"
        case currentUsage = "CURRENT_USAGE"
        case loanBalance = "LOAN_BALANCE"
        case hasActivatedWallet = "HAS_ACTIVATED_WALLET"
        case walletAccountID = "WALLET_ACCOUNT_ID"
        case walletAccountNumber = "WALLET_ACCOUNT_NUMBER"
//        case walletBalance = "WALLET_BALANCE"
        case freshchatRestorationID = "FRESHCHAT_RESTORATION_ID"
        case loyaltyPoints = "LOYALTY_POINTS"
        case identity = "IDENTITY"
        case postalAddress = "POSTAL_ADDRESS"
        case acceptedTacVersion = "ACCEPTED_TAC_VERSION"
        case dateAcceptedTac = "DATE_ACCEPTED_TAC"
        case nationalid = "NATIONALID"
        case hasBritamAccount = "HAS_BRITAM_ACCOUNT"
        case britamWalletData = "BRITAM_WALLET_DATA"
    }

}
