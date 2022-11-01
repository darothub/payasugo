//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public class TransactionHistoryImpl: TransactionHistoryRepository {
    var dbObserver: Observer<TransactionHistory>
    /// ``TransactionHistoryImpl`` initialiser
    /// - Parameter dbObserver: ``Observer``
    public init(dbObserver: Observer<TransactionHistory>) {
        self.dbObserver = dbObserver
    }
    
    public func getHistory() -> [TransactionHistory] {
        dbObserver.getEntities()
    }
}

public protocol TransactionHistoryRepository {
    func getHistory() -> [TransactionHistory]
}
