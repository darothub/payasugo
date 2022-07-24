//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/07/2022.
//

import Foundation
public struct ProfileInfo: Codable {
    public var mulaProfile: [Profile]
//    public var paymentOptions: [MulaProfileInfoPaymentOption]
//    public var wishlist: [Wishlist]
//    public var cardInfo: CardInfo
//    public var extProfileData: EXTProfileData

    enum CodingKeys: String, CodingKey {
        case mulaProfile = "MULA_PROFILE"
//        case paymentOptions = "PAYMENT_OPTIONS"
//        case wishlist = "WISHLIST"
//        case cardInfo = "CARD_INFO"
//        case extProfileData = "EXT_PROFILE_DATA"
    }
}

//// MARK: - MulaProfileInfoPaymentOption
//public struct MulaProfileInfoPaymentOption: Codable {
//    public var hubClientID, clientName, clientCode, isSelected: String
//    public var paymentOptionID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case hubClientID = "HUB_CLIENT_ID"
//        case clientName = "CLIENT_NAME"
//        case clientCode = "CLIENT_CODE"
//        case isSelected = "IS_SELECTED"
//        case paymentOptionID = "PAYMENT_OPTION_ID"
//    }
//}

//// MARK: - Wishlist
//public struct Wishlist: Codable {
//    public var name: Name
//    public var referenceNo, paybill, paymentOptionID: String
//    public var active: ActiveStatus
////    public var dateCreated: DateCreated
//    public var wishlistID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case name = "NAME"
//        case referenceNo = "REFERENCE_NO"
//        case paybill = "PAYBILL"
//        case paymentOptionID = "PAYMENT_OPTION_ID"
//        case active = "ACTIVE"
////        case dateCreated = "DATE_CREATED"
//        case wishlistID = "WISHLIST_ID"
//    }
//}
