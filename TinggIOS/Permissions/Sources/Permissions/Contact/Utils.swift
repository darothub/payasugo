//
//  File.swift
//  
//
//  Created by Abdulrasaq on 21/12/2022.
//

import Foundation
import SwiftUI
public func showContactView(contactViewModel: ContactViewModel) -> some View {
    return ContactRowView(listOfContactRow: contactViewModel.listOfContact.sorted(by: <)){contact in
        contactViewModel.selectedContact = contact.phoneNumber
    }
}
