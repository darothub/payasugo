//
//  Contact.swift
//  Core
//
//  Created by Abdulrasaq on 31/05/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - Contact
public class Contact: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var email: String? = ""
    @Persisted public var facebook: String? = ""
    @Persisted public var phone: String? = ""
    @Persisted public var link: String? = ""
    @Persisted public var twitter: String? = ""
    @Persisted public var countryID: String? = ""
    @Persisted public var website: String? = ""
    @Persisted public var address: String? = ""
    @Persisted public var location: String? = ""
    @Persisted public var contactTitle: String? = ""
    @Persisted public var dateCreate: String? = ""

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

//    init(
//        email: String?, facebook: String?, phone: String?,
//        link: String?, twitter: String?, countryID: String?,
//        website: String?, address: String?, location: String?,
//        contactTitle: String?, dateCreate: String?
//    ) {
//        self.email = email
//        self.facebook = facebook
//        self.phone = phone
//        self.link = link
//        self.twitter = twitter
//        self.countryID = countryID
//        self.website = website
//        self.address = address
//        self.location = location
//        self.contactTitle = contactTitle
//        self.dateCreate = dateCreate
//    }
}
