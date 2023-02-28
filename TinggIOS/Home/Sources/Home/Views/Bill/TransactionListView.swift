//
//  TransactionListView.swift
//  
//
//  Created by Abdulrasaq on 27/02/2023.
//

import SwiftUI

struct TransactionListView: View {
    @State var listOfModel = [TransactionSectionModel.sample, TransactionSectionModel.sample2]
    var body: some View {
        List(listOfModel, id: \.id) { model in
            Section(model.header) {
                ForEach(model.list) { item in
                    TransactionItemView(model: item)
                }
            }
        }
    }
}



struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
