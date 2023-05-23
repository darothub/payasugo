//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
/// A class type for fetching nested arrays of categories
public class ChunkedCategoriesUsecase {
    private let categoryRepository: CategoryRepository
    
    /// ``ChunkedCategoriesUsecase`` initialiser
    /// - Parameter categoryRepository: ``CategoryRepositoryImpl``
    public init(categoryRepository: CategoryRepository){
        self.categoryRepository = categoryRepository
    }
    
    /// A call as function to return a list of nested list of categories
    /// - Returns: ``[[Categorys]]``
    public func callAsFunction() -> [[CategoryEntity]] {
        let categories = categoryRepository.getCategories().sorted { c1, c2 in
            c1.categoryOrderID!.convertStringToInt() < c2.categoryOrderID!.convertStringToInt()
        }
        return categories.chunked(into: 4)
    }
}
