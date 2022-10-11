//
//  ContactManager.swift
//  Permissions
//
//  Created by Abdulrasaq on 15/06/2022.
//

import Contacts
import Foundation

public struct ContactManager {
    
    let store = CNContactStore()
    let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
    let fetchRequest: CNContactFetchRequest
    public static let shared = ContactManager()
    public init(){
        fetchRequest = CNContactFetchRequest(keysToFetch: keys)
    }
    
    public func fetchContacts(onCompletion: @escaping (CNContact) -> Void) async {
        
        do{
            try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, unsafeMutablePoint in
                print(contact)
                onCompletion(contact)
            })
        }catch {
            print("Contact error \(error)")
        }
        
    }
    
}
