//
//  TransactionListView.swift
//  
//
//  Created by Abdulrasaq on 27/02/2023.
//
import CoreUI
import Core
import SwiftUI



struct TransactionListView: View {
    @Binding var listOfModel: [TransactionSectionModel]
    @State var onDelete: Bool = false
    var deleteClosure:(String, Int) -> Void = {_, _ in
        //TODO
    }
    var body: some View {
        List {
            ForEach(listOfModel) { model in
                Section(model.header) {
                    var transactionItemModelList = model.list.sorted()
                    ForEach(transactionItemModelList) { item in
                        TransactionItemView(model: item) { delete in
                            if delete {
                                removeItem(item: item, from: &transactionItemModelList)
                                removeTransactionFromDB(item: item)
                                if transactionItemModelList.isEmpty {
                                    removeTheSection(section: model)
                                }
                            }
                        }
                    
                    }
                }
            }.background(.white)
    
        }
        .background(.white)
        .scrollContentBackground(.hidden)
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



struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(listOfModel: .constant([]))
    }
}
