//
//  ChunkedCategoriesUsecaseTest.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//

import XCTest
import Core

class ChunkedCategoriesUsecaseTest: XCTestCase {
    private var categoryRepository: CategoryRepository!
    private var usecase: ChunkedCategoriesUsecase!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        categoryRepository = FakeCategoryRepository(dbObserver: Observer<Categorys>())
        usecase = ChunkedCategoriesUsecase(categoryRepository: categoryRepository)
    }

    func testChunkedCategories() {
        let chunked = usecase()
        let actual = chunked.count
        let expected = 1
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
    func testChunkedCategoriesContainASubListOfFourCategories() {
        let chunked = usecase()
        let actual = chunked[0].count
        let expected = 4
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
}
