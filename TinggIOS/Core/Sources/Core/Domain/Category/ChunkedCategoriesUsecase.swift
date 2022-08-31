//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public class ChunkedCategoriesUsecase {
    private let categoryRepository: CategoryRepository
    public init(categoryRepository: CategoryRepository){
        self.categoryRepository = categoryRepository
    }
    
    public func callAsFunction() -> [[Categorys]] {
        let categories = categoryRepository.getCategories()
        return categories.chunked(into: 4)
    }
}
