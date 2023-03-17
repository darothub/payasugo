//
//  CategoryRepositoryTest.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//
import Core
import RealmSwift
import XCTest

class CategoryRepositoryTest: XCTestCase {
    private var categoryRepository: CategoryRepository!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        categoryRepository = FakeCategoryRepository(dbObserver: Observer<CategoryEntity>())
    }
    
    func testGetCategories() {
        let categories = categoryRepository.getCategories()
        let actual = categories.count
        let expected = 4
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }

}
