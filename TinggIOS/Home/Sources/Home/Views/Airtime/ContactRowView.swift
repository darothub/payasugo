//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 12/10/2022.
//

import SwiftUI

struct ContactRowView: View {
    var listOfContactRow = [ContactRow]()
    var onContactSelected: (ContactRow) -> Void
    var body: some View {
        List {
            ForEach(listOfContactRow, id: \.phoneNumber) { row in
                HImageAndNameView(text: row.name, image: row.image)
                    .onTapGesture {
                        onContactSelected(row)
                    }
            }
        }
    }
}


struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContactRowView() {$0}
    }
}


struct ContactRow: Hashable, Comparable {
    var name: String
    var image: Image?
    var phoneNumber: String
    
    public func hash(into hasher: inout Hasher) {
          return hasher.combine(phoneNumber)
    }
    public static func == (lhs: ContactRow, rhs: ContactRow) -> Bool {
          return lhs.phoneNumber == rhs.phoneNumber
    }
    static func < (lhs: ContactRow, rhs: ContactRow) -> Bool {
        lhs.name < rhs.name
    }
}
