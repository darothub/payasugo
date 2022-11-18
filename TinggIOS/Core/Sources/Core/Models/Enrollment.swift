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
public class Enrollment: Object, DBObject,  ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var clientProfileAccountID: Int = 0
    @Persisted public var merchantName: String?
    @Persisted public var merchantID: Int?
    @Persisted public var merchantCode: String?
    @Persisted public var serviceName: String?
    @Persisted public var hubServiceID: Int = 0
    @Persisted public var serviceCode: String?
    @Persisted public var accountNumber: String?
    @Persisted public var accountName: String?
    @Persisted public var accountAlias: String?
    @Persisted public var accountID: String?
    @Persisted public var isExplicit: String?
    @Persisted public var extraData: String?
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
}


public var sampleNomination: Enrollment {
    let nom = Enrollment()
    nom.serviceName = "PDSL Postpaid"
    nom.serviceCategoryID = "3"
    nom.serviceLogo = "https://mula.co.ke/mula_ke/api/v1/images/services/KPLC_PayBill.png"
    nom.accountStatus = 1
    nom.hubServiceID = 44
    nom.accountNumber = "112796982"
    nom.accountName = "KPLC Postpaid"
    nom.accountAlias = "FARGO COURIER LTD"
    nom.clientProfileAccountID = 35732900
    return nom
}
public var sampleNomination2: Enrollment {
    let nom = Enrollment()
    nom.serviceName = "Startimes Kenya"
    nom.serviceCategoryID = "1"
    nom.serviceLogo = "https://mula.co.ke/mula_ke/api/v1/images/services/Startimes-logo-400x400.gif"
    nom.accountStatus = 1
    nom.hubServiceID = 54
    nom.accountNumber = "1801744410"
    nom.accountName = "Startimes"
    nom.accountAlias = "N/A"
    nom.clientProfileAccountID = 42815952
    return nom
}

public var sampleNomination3: Enrollment {
    let nom = Enrollment()
    nom.serviceName = "GOTV Kenya"
    nom.serviceCategoryID = "1"
    nom.serviceLogo = "https://mula.co.ke/mula_ke/api/v1/images/services/gotv.jpg"
    nom.accountStatus = 1
    nom.hubServiceID = 2
    nom.accountNumber = "2014183174"
    nom.accountName = "GOtv"
    nom.accountAlias = "DANIEL KIMAN"
    nom.clientProfileAccountID = 35732528
    return nom
}
public var sampleNominations: [Enrollment] {
    let nom1 = sampleNomination
    let nom2 = sampleNomination2
    let nom3 = sampleNomination3
    return [nom1, nom2, nom3]
}


