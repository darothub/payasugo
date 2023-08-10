//
//  File.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//
import Contacts
import Foundation
import SwiftUI
import Combine
public class ContactViewModel: ObservableObject {
    @Published public var selectedContact: String = ""
    @Published public var showContact = false
    @Published public var listOfContact = Set<ContactRow>()
    @Published public var contacts: CNContact = .init()
    @Published var contactManager = ContactManager()
    public var subscriptions = Set<AnyCancellable>()
    public init() {
        //
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
    public func fetchPhoneContacts(onError: @escaping (Error) -> Void) async {
        await contactManager.fetchContacts { [unowned self] result in
             switch result {
             case .failure(let error):
                 onError(error)
             case .success(let c):
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
                     listOfContact.insert(handleContacts(contacts: c))
                     showContact = true
                 }
             }
         }
        
    }
    public func fetchPhoneContactsWIthoutUI(onSuccess: @escaping (ContactRow) -> Void,  onError: @escaping (Error) -> Void) async {
        await contactManager.fetchContacts { [unowned self] result in
             switch result {
             case .failure(let error):
                 onError(error)
             case .success(let c):
                 onSuccess(handleContacts(contacts: c))
             }
         }
        
    }
}


public protocol ContactListener {
    func onContactFetched(_ contacts: Set<ContactRow>)
    func onError(_ error: String)
}
