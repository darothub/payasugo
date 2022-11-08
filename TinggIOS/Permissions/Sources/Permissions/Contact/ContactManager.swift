//
//  ContactManager.swift
//  Permissions
//
//  Created by Abdulrasaq on 15/06/2022.
//

import Contacts
import Foundation

public class ContactManager: ObservableObject {
    
    let store = CNContactStore()
    let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey, CNContactFamilyNameKey, CNContactImageDataKey] as [CNKeyDescriptor]
    let fetchRequest: CNContactFetchRequest
    let permission: ContactPermission = .init()
    public static let shared = ContactManager()
    
    public init(){
        fetchRequest = CNContactFetchRequest(keysToFetch: keys)
    }
    
    public func fetchContacts(onCompletion: @escaping (Result<CNContact, Error>) -> Void) async {
        permission.requestAccess()
        do{
            if permission.invalidPermission {
                onCompletion(.failure(ContactPermissionError.Unauthorized))
            } else {
                try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, unsafeMutablePoint in
                    onCompletion(.success(contact))
                })
            }
          
        }catch {
            print("Contact error \(error)")
            onCompletion(.failure(error))
        }
        
    }
    
}
