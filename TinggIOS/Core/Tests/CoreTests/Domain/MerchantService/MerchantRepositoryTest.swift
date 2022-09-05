//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//
import Core
import Foundation
import RealmSwift
import XCTest
class MerchantRepositoryTest: XCTestCase {
    var merchantServiceRepository: MerchantServiceRepository?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        merchantServiceRepository = FakeMerchantRepository(dbObserver: Observer<MerchantService>())
    }
    
    func testGetServices(){
        let services = merchantServiceRepository?.getServices()
        let actual = services?.count
        let expected = 3
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
    
}
