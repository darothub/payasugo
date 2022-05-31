//
//  Card.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation
public class Card : Identifiable, Codable {
    public let firstName: String? = nil
    public let middleName: String? = nil
    public let idPassport: String? = nil
    public let phoneNumber: String? = nil
    public let email: String? = nil
    public let customerAddress: String? = nil
    public let currencyCode: String? = nil
    public let customerCity: String? = nil
    public let countryCode: String? = nil
    public let alias: String = ""
    public let nameType: String? = nil
    public let payerClientId: String? = nil
    public let suffix: String? = nil
    public let activeStatus: String? = nil
    public let validationServiceID: String? = nil
    public let type: String? = nil
    public let countryDialCode: String? = nil
//    var merchantPayer: MerchantPayer? = nil
    enum CodingKeys: String, CodingKey {
        case firstName = "FIRST_NAME"
        case middleName = "MIDDLE_NAME"
        case idPassport = "ID_PASSPORT"
        case phoneNumber = "PHONE_NUMBER"
        case email = "EMAIL"
        case customerAddress = "CUSTOMER_ADDRESS"
        case currencyCode = "CURRENCY_CODE"
        case customerCity = "CUSTOMER_CITY"
        case countryCode = "COUNTRY_CODE"
        case alias = "CARD_ALIAS"
        case nameType = "CARD_NAME_TYPE"
        case payerClientId = "PAYER_CLIENT_ID"
        case suffix = "CARD_NUMBER_SUFFIX"
        case activeStatus = "ACTIVE_STATUS"
        case type = "CARD_TYPE"
        case validationServiceID = "VALIDATION_SERVICE_ID"
        case countryDialCode = "COUNTRY_DAILCODE"
//        case merchantPayer = "merchant_payer_"
    }
}
