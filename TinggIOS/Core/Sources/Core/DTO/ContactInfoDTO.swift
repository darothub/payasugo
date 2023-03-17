//
//  ContactInfoDTO.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation
// MARK: - ContactInfo
public struct ContactInfoDTO: Codable {
    public let contactTitle, location, phone, address: String
    public let email: String
    public let twitter, facebook: String
    public let website: String
    public let link: String
    public let countryID: String

    enum CodingKeys: String, CodingKey {
        case contactTitle = "CONTACT_TITLE"
        case location = "LOCATION"
        case phone = "PHONE"
        case address = "ADDRESS"
        case email = "EMAIL"
        case twitter = "TWITTER"
        case facebook = "FACEBOOK"
        case website = "WEBSITE"
        case link = "LINK"
        case countryID = "COUNTRY_ID"
    }
    
    public var toEntity: Contact {
        var entity = Contact()
        entity.address = self.address
        entity.phone = self.phone
        entity.contactTitle = self.contactTitle
        entity.email = self.email
        entity.website = self.website
        entity.link = self.link
        entity.countryID = self.countryID
        entity.twitter = self.twitter
        entity.facebook = self.facebook
        entity.location = self.location
        return entity
    }
}
