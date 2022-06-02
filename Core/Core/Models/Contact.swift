//
//  Contact.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//

import Foundation

// MARK: - Contact
public class Contact: Identifiable, Codable {
    public let id: Int
    public let email, facebook, phone, link: String?
    public let twitter, countryID, website, address: String?
    public let location, contactTitle, dateCreate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email = "EMAIL"
        case facebook = "FACEBOOK"
        case phone = "PHONE"
        case link = "LINK"
        case twitter = "TWITTER"
        case countryID = "COUNTRY_ID"
        case website = "WEBSITE"
        case address = "ADDRESS"
        case location = "LOCATION"
        case contactTitle = "CONTACT_TITLE"
        case dateCreate
    }

    init(id: Int, email: String?, facebook: String?, phone: String?, link: String?, twitter: String?, countryID: String?, website: String?, address: String?, location: String?, contactTitle: String?, dateCreate: String?) {
        self.id = 0
        self.email = email
        self.facebook = facebook
        self.phone = phone
        self.link = link
        self.twitter = twitter
        self.countryID = countryID
        self.website = website
        self.address = address
        self.location = location
        self.contactTitle = contactTitle
        self.dateCreate = dateCreate
    }
}
