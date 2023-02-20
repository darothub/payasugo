//
//  DTBAccountResponse.swift
//  
//
//  Created by Abdulrasaq on 17/02/2023.
//
import Core
import Foundation


public struct DTBAccountsResponse: BaseDTOprotocol {
    public var statusMessage: String
    public var statusCode: Int = 0
    public var accounts: [DTBAccount]? = nil

    
    public init(accounts: [DTBAccount]? = nil, statusCode: Int, statusMessage: String) {
        self.accounts = accounts
        self.statusCode = statusCode
        self.statusMessage = statusMessage
    }
    enum CodingKeys: String, CodingKey {
          case statusCode = "STATUS_CODE"
          case statusMessage = "STATUS_MESSAGE"
          case accounts = "ACCOUNTS"
    }
}

public struct DTBAccount: Decodable {
    var currency: String? = nil
    var profileId: String? = nil
    var accountId: String? = nil
    var alias: String? = nil
    var currencyNumber: String? = nil
    var accountNumber: String? = nil
    var currencyCode: String? = nil
    
    public init(currency: String? = nil, profileId: String? = nil, accountId: String? = nil, alias: String? = nil, currencyNumber: String? = nil, accountNumber: String? = nil, currencyCode: String? = nil) {
        self.currency = currency
        self.profileId = profileId
        self.accountId = accountId
        self.alias = alias
        self.currencyNumber = currencyNumber
        self.accountNumber = accountNumber
        self.currencyCode = currencyCode
    }
    
    enum CodingKeys: String, CodingKey {
        case currency = "CURRENCY"
        case profileId = "PROFILE_ID"
        case accountId = "ACCOUNT_ID"
        case alias = "ACCOUNT_ALIAS"
        case currencyNumber = "CURRENCY_NUMBER"
        case accountNumber = "ACCOUNT_NUMBER"
        case currencyCode = "CURRENCY_CODE"
    }
}
