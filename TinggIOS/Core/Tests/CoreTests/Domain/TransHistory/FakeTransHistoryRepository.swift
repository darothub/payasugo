//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/09/2022.
//

import Foundation
import Core
import RealmSwift
class FakeTransactionHistoryRepository: TransactionHistoryRepository {
    var dbObserver: Observer<TransactionHistory>
    let realm: RealmManager = .init()
    public init(dbObserver: Observer<TransactionHistory>) {
        self.dbObserver = dbObserver
        let transactionOne = TransactionHistory()
        transactionOne.payerTransactionID = "payerTransactionID1"
        transactionOne.paymentDate = "2022-08-25 12:15:06.0"
        transactionOne.amount = "10.0"
        let transactionTwo = TransactionHistory()
        transactionTwo.payerTransactionID = "payerTransactionID2"
        transactionTwo.paymentDate = "2022-07-22 13:19:21.0"
        transactionTwo.amount = "20.0"
        let fakeData = [transactionOne, transactionTwo]
        realm.invalidate()
        realm.save(data: fakeData)
        
    }
  
    public func getHistory() -> [TransactionHistory] {
        dbObserver.getEntities()
    }
}
