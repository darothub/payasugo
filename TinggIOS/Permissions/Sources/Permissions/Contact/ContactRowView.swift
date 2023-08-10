//
//  ContactRowView.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//

import SwiftUI

public struct ContactRowView: View {
    @State var listOfContactRow = [ContactRow]()
    @StateObject var contactVm = ContactViewModel()
    var onContactSelected: (ContactRow) -> Void
    var onFailure: (String) -> Void
    @Environment(\.dismiss) var dismiss
    public init(onContactSelected: @escaping (ContactRow) -> Void, onFailure: @escaping (String) -> Void) {
        self.onContactSelected = onContactSelected
        self.onFailure = onFailure
    }
    public var body: some View {
        List {
            ForEach(contactVm.listOfContact.sorted(), id: \.phoneNumber) { row in
                HImageAndNameView(text: row.name, image: row.image)
                    .onTapGesture {
                        onContactSelected(row)
                        dismiss()
                    }
            }
        }
        .onAppear {
            Task {
                await contactVm.fetchPhoneContacts { err in
                    onFailure(err.localizedDescription)
                }
            }
        }
    }
}


struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContactRowView(onContactSelected: { c in
            //
        }, onFailure: { err in
            //
        })
    }
}

