//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/09/2022.
//

import Core
import Foundation
import RealmSwift
import XCTest
class TransactionHistoryRepositoryTest: XCTestCase {
    var transHistoryRepository: TransactionHistoryRepository?
    var history: [TransactionHistory]?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        transHistoryRepository = FakeTransactionHistoryRepository(dbObserver: Observer<TransactionHistory>())
        history = transHistoryRepository?.getHistory()
    }
    
    func testGetSavedTransactionHistory(){
        let expected = 2
        XCTAssertEqual(history?.count, expected, "Expected \(expected) but found \(String(describing: history?.count))")
    }
    
    func testItemContained(){
        let itemOne = history![0]
        let actualDate = itemOne.paymentDate
        let expected = "2022-08-25 12:15:06.0"
        XCTAssertEqual(actualDate, expected, "Expected \(expected) but found \(String(describing: actualDate))")
    }
   
}
