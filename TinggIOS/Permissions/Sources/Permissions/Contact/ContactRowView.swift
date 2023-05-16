//
//  ContactRowView.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//

import SwiftUI

public struct ContactRowView: View {
    @State var listOfContactRow = [ContactRow]()
    var onContactSelected: (ContactRow) -> Void
    @Environment(\.dismiss) var dismiss
    public init(listOfContactRow: [ContactRow] = [ContactRow](), onContactSelected: @escaping (ContactRow) -> Void = {_ in
        //TODO
    }) {
        self._listOfContactRow = State(initialValue: listOfContactRow)
        self.onContactSelected = onContactSelected
    }
    public var body: some View {
        List {
            ForEach(listOfContactRow, id: \.phoneNumber) { row in
                HImageAndNameView(text: row.name, image: row.image)
                    .onTapGesture {
                        onContactSelected(row)
                        dismiss()
                    }
            }
        }
    }
}


struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContactRowView()
    }
}

