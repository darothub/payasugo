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
    let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
    let fetchRequest: CNContactFetchRequest
    let permission: ContactPermission = .init()
    public static let shared = ContactManager()
    
    public init(){
        fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        permission.requestAccess()
    }
    
    public func fetchContacts(onCompletion: @escaping (Result<CNContact, Error>) -> Void) async {
        
        do{
            if permission.invalidPermission {
                onCompletion(.failure(ContactPermissionError.Unauthorized))
            } else {
                try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, unsafeMutablePoint in
//                    print(contact)
                    onCompletion(.success(contact))
                })
            }
          
        }catch {
            print("Contact error \(error)")
            onCompletion(.failure(error))
        }
        
    }
    
}
