//
//  TransactionListView.swift
//  
//
//  Created by Abdulrasaq on 27/02/2023.
//
import Common
import Core
import SwiftUI

struct TransactionListView: View {
    @State var listOfModel = [TransactionSectionModel.sample, TransactionSectionModel.sample2]
    var onMenuClick:(Int) -> Void = {_ in }
    @State private var isFullScreen = false
    var body: some View {
        List(listOfModel, id: \.id) { model in
            Section(model.header) {
                ForEach(model.list) { item in
                    TransactionItemView(model: item) {_ in
                        isFullScreen.toggle()
                    }
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
