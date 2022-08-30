//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//
import Core
import Foundation
import XCTest
import RealmSwift
class HomeUsecaseTests: XCTestCase {
    var homeUsecase: HomeUsecase?
    override func setUpWithError() throws {
        homeUsecase = FakeHomeUsecase(merchantServiceRepository: FakeMerchantRepository())
    }
    
    func testGetDisplayedRechargeAndBill() {
        let data = homeUsecase?.displayedRechargeAndBill()
        XCTAssertNotEqual(data, nil, "Error has occurred")
    }
    
    func testDispayedRechargeAndBillCountIsEight() {
        let data = homeUsecase?.displayedRechargeAndBill()
        XCTAssertEqual(data?.count, 8, "Error has occurred")
    }
}
