//
//  TransactionListView.swift
//  
//
//  Created by Abdulrasaq on 17/04/2023.
//
import Checkout
import CoreUI
import Core
import Foundation
import SwiftUI

struct TransactionListView: View {
    @Binding var listOfModel: [TransactionSectionModel]
    @State var onDelete: Bool = false
    private let colors: [Color] = [.green, .blue, .purple, .pink, .orange]
    private var selectedColorForName: Color {
        colors.randomElement() ?? .green
    }
 
    var deleteClosure:(String, Int) -> Void = {_, _ in
        //TODO
    }
    var body: some View {
        List {
            ForEach(listOfModel) { model in
                Section(model.header) {
                    var transactionItemModelList = model.list
                    ForEach(transactionItemModelList) { item in
                        let color = colors.randomElement() ?? .gray
                        SingleVirtualCardTransactionView(selectedColorForName: color)
                    }
                }
            } .listRowInsets(EdgeInsets())
        }
        .padding()
        .scrollIndicators(.hidden)
        .listStyle(PlainListStyle())
           
    }

    fileprivate func removeTransactionFromDB(item: TransactionItemModel) {
        let db = Observer<TransactionHistory>()
        let transactionsHistoryEntities = db.getEntities()
        let thisTransaction = transactionsHistoryEntities.first(where: { t in
            t.beepTransactionID == item.id
        })
        if let unWrappedTransaction = thisTransaction {
            db.$objects.remove(unWrappedTransaction)
        }
    }
    
    fileprivate func removeItem(item: TransactionItemModel, from list: inout [TransactionItemModel]) {
        let itemIndexInSectionList = list.firstIndex(of: item)
        list.remove(at: itemIndexInSectionList!)
    }
    
    fileprivate func removeTheSection(section: TransactionSectionModel) {
        let modelIndex = listOfModel.firstIndex(of: section)
        listOfModel.remove(at: modelIndex!)
    }
}
