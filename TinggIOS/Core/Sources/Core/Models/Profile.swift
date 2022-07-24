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
public class Profile: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var profileID: String = ""
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
    @Persisted public var isMulaPinSet: String? = ""
    @Persisted public var isMain: String? = ""
    @Persisted public var simSerialNumber: String? = ""
    @Persisted public var hasValidatedCard: Int? = 0
    @Persisted public var creditLimit: String? = ""
    @Persisted public var hasActivatedAssist: String? = ""
    @Persisted public var hasOptedOut: String? = ""
    @Persisted public var currentUsage: Int? = 0
    @Persisted public var loanBalance: Int? = 0
    @Persisted public var hasActivatedWallet: String? = ""
    @Persisted public var walletAccountID: String? = ""
    @Persisted public var walletAccountNumber: String? = ""
    @Persisted public var walletBalance: String? = ""
    @Persisted public var freshchatRestorationID: String? = ""
    @Persisted public var loyaltyPoints: String? = ""
    @Persisted public var identity: String? = ""
    @Persisted public var postalAddress: String? = ""
    @Persisted public var acceptedTacVersion: Int? = 0
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
        case walletBalance = "WALLET_BALANCE"
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
//    init(profileID: Int, msisdn: String?, firstName: String?,
//         lastName: String?, emailAddress: String?, photoURL: String?,
//         accountID: String?, accountAlias: String?, accountNumber: String?,
//         profileProfileID: String?, currency: String?, currencyCode: String?,
//         rewardAmount: String?, mulaAccount: String?, currencyNumber: String?,
//         pinRequestType: String?, isMulaPinSet: String?, isMain: String?,
//         simSerialNumber: String?, hasValidatedCard: String?, creditLimit: String?,
//         hasActivatedAssist: String?, hasOptedOut: String?, currentUsage: String?,
//         loanBalance: String?, hasActivatedWallet: String?, walletAccountID: String?,
//         walletAccountNumber: String?, walletBalance: String?, freshchatRestorationID: String?,
//         loyaltyPoints: String?, identity: String?, postalAddress: String?,
//         acceptedTacVersion: String?, dateAcceptedTac: String?, nationalid: String?,
//         hasBritamAccount: String?, britamWalletData: String?
//    ) {
//        self.profileID = profileID
//        self.msisdn = msisdn
//        self.firstName = firstName
//        self.lastName = lastName
//        self.emailAddress = emailAddress
//        self.photoURL = photoURL
//        self.accountID = accountID
//        self.accountAlias = accountAlias
//        self.accountNumber = accountNumber
//        self.profileProfileID = profileProfileID
//        self.currency = currency
//        self.currencyCode = currencyCode
//        self.rewardAmount = rewardAmount
//        self.mulaAccount = mulaAccount
//        self.currencyNumber = currencyNumber
//        self.pinRequestType = pinRequestType
//        self.isMulaPinSet = isMulaPinSet
//        self.isMain = isMain
//        self.simSerialNumber = simSerialNumber
//        self.hasValidatedCard = hasValidatedCard
//        self.creditLimit = creditLimit
//        self.hasActivatedAssist = hasActivatedAssist
//        self.hasOptedOut = hasOptedOut
//        self.currentUsage = currentUsage
//        self.loanBalance = loanBalance
//        self.hasActivatedWallet = hasActivatedWallet
//        self.walletAccountID = walletAccountID
//        self.walletAccountNumber = walletAccountNumber
//        self.walletBalance = walletBalance
//        self.freshchatRestorationID = freshchatRestorationID
//        self.loyaltyPoints = loyaltyPoints
//        self.identity = identity
//        self.postalAddress = postalAddress
//        self.acceptedTacVersion = acceptedTacVersion
//        self.dateAcceptedTac = dateAcceptedTac
//        self.nationalid = nationalid
//        self.hasBritamAccount = hasBritamAccount
//        self.britamWalletData = britamWalletData
//    }
}
