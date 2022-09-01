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
class BarChartUsecaseTest: XCTestCase {
    var transHistoryRepository: TransactionHistoryRepository?
    var barChartUsecase: BarChartUsecase!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        transHistoryRepository = FakeTransactionHistoryRepository(dbObserver: Observer<TransactionHistory>())
        barChartUsecase = BarChartUsecase(transactHistoryRepository: transHistoryRepository!)
    }
    
    func testBarchartUsecaseReturnsADictionary(){
        let actual = barChartUsecase()
       
        XCTAssertNotEqual(actual, nil, "Not Expecting \(actual) to be nil")
    }
    
    func testThatBarchartDictionaryIsCorrect(){
        let chartMap = barChartUsecase()
        let actualAmountForAugust = chartMap[8]
        let expectedAmount = 10.0
        XCTAssertEqual(actualAmountForAugust, expectedAmount, "Expected \(expectedAmount) but found \(String(describing: actualAmountForAugust))")
    }
}
