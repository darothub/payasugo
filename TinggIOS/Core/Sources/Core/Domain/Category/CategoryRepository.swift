//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public class CategoryRepositoryImpl: CategoryRepository {
    private var dbObserver: Observer<Categorys>
    public init(dbObserver: Observer<Categorys>) {
        self.dbObserver = dbObserver
    }
    
    public func getCategories() -> [Categorys] {
        return dbObserver.objects.map(returnCategories(category:))
    }
    
    private func returnCategories(category: Categorys) -> Categorys{
        return category
    }
}

public protocol CategoryRepository {
    func getCategories() -> [Categorys]
}
