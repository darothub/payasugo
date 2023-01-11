//
//  File.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//
import Contacts
import Foundation
import SwiftUI

public struct ContactRow: Hashable, Comparable {
    public var name: String
    public var image: Image?
    public var phoneNumber: String
    public init(name: String, image: Image? = nil, phoneNumber: String) {
        self.name = name
        self.image = image
        self.phoneNumber = phoneNumber
    }
    public func hash(into hasher: inout Hasher) {
          return hasher.combine(phoneNumber)
    }
    public static func == (lhs: ContactRow, rhs: ContactRow) -> Bool {
          return lhs.phoneNumber == rhs.phoneNumber
    }
    public static func < (lhs: ContactRow, rhs: ContactRow) -> Bool {
        lhs.name < rhs.name
    }
    
}

public func handleContacts(contacts: CNContact) -> ContactRow {
    let name = contacts.givenName + " " + contacts.familyName
    var phoneNumber = ""
    for number in contacts.phoneNumbers  {
        print("Numbers \(number)")
        switch number.label {
        default:
            let mobile = number.value.stringValue
            phoneNumber = mobile
        }
    }
    if let thumbnailData = contacts.imageData, let uiImage = UIImage(data: thumbnailData) {
        let contactImage = Image(uiImage: uiImage)
        let contactRow = ContactRow(name: name, image: contactImage, phoneNumber: phoneNumber)
        return contactRow
    }
    let contactRow = ContactRow(name: name, image: nil, phoneNumber: phoneNumber)
    return contactRow
}
