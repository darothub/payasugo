//
//  Card.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - Card
public class Card: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted public var firstName: String? = ""
    @Persisted public var middleName: String? = ""
    @Persisted public var idPassport: String? = ""
    @Persisted public var phoneNumber: String? = ""
    @Persisted public var email: String? = ""
    @Persisted public var customerAddress: String? = ""
    @Persisted public var currencyCode: String? = ""
    @Persisted public var customerCity: String? = ""
    @Persisted public var countryCode: String? = ""
    @Persisted(primaryKey: true) public var cardAlias: String? = ""
    @Persisted public var nameType: String? = ""
    @Persisted public var payerClientID: String? = ""
    @Persisted public var suffix: String? = ""
    @Persisted public var activeStatus: String? = ""
    @Persisted public var validationServiceID: String? = ""
    @Persisted public var cardType: String? = ""
    @Persisted public var countryDialCode: String? = ""
    //Tingg Virtual Card
    public static let TYPE_VIRTUAL = "VIRTUAL"
    // Normal credit cards
    public static let TYPE_NORMAL = "NORMAL"
    public static let STATUS_INACTIVE = "0"
    public static let  STATUS_ACTIVE = "1"
    
    enum CodingKeys: String, CodingKey {
        case firstName, middleName, idPassport, phoneNumber, email, customerAddress, currencyCode, customerCity, countryCode
        case cardAlias = "CARD_ALIAS"
        case nameType
        case payerClientID = "PAYER_CLIENT_ID"
        case suffix
        case activeStatus = "ACTIVE_STATUS"
        case validationServiceID
        case cardType = "CARD_TYPE"
        case countryDialCode
    }
    public func isInActive() -> Bool {
        return self.activeStatus == Card.STATUS_INACTIVE
    }
    public func isActive() -> Bool {
        return self.activeStatus == Card.STATUS_ACTIVE
    }
}


public enum CardType: String {
    case visa, mastercard, amex, DINERS, discover, jcb, CarteBlanche, EnRoute, none
}
