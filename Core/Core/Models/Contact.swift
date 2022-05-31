//
//  Contact.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation

public class Contact : Identifiable, Encodable {
    public let id: Int64 = 0
    public let email: String? = ""
    public let facebookUrl: String? = ""
    public let phone: String? = ""
    public let googlePlayUrl: String? = ""
    public let twitterUrl: String? = ""
    public let countryID: String? = ""
    public let website: String? = ""
    public let address: String? = ""
    public let location: String? = ""
    public let title: String? = ""
    public let dateCreate: String = ""
    enum CodingKeys: String, CodingKey {
        case id = "CONTACTS_ID"
        case email = "EMAIL"
        case facebookUrl = "FACEBOOK"
        case phone = "PHONE"
        case googlePlayUrl = "LINK"
        case twitterUrl = "TWITTER"
        case countryID = "COUNTRY_ID"
        case website = "WEBSITE"
        case address = "ADDRESS"
        case location = "LOCATION"
        case title = "CONTACT_TITLE"
        
    }
}
