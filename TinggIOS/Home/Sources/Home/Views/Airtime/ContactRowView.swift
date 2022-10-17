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
            ForEach(listOfContactRow, id: \.id) { row in
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


struct ContactRow: Identifiable {
    var id = UUID()
    var name: String
    var image: Image?
    var phoneNumber: String
}
