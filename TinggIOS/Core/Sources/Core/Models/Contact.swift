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
    @Persisted public var id: ObjectId
    //    @Persisted public var email: String? = ""
    //    @Persisted public var facebook: String? = ""
    //    @Persisted public var phone: String? = ""
    //    @Persisted public var link: String? = ""
    //    @Persisted public var twitter: String? = ""
    //    @Persisted public var countryID: String? = ""
    //    @Persisted public var website: String? = ""
    //    @Persisted public var address: String? = ""
    //    @Persisted public var location: String? = ""
    //    @Persisted public var contactTitle: String? = ""
    //    @Persisted public var dateCreate: String? = ""
    @Persisted public var contactTitle: String
    @Persisted public var location: String
    @Persisted public var phone: String
    @Persisted public var address: String
    @Persisted public var email: String
    @Persisted public var twitter: String
    @Persisted public var facebook: String
    @Persisted public var website: String
    @Persisted public var link: String
    @Persisted public var countryID: String
    
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
}
