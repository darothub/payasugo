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
        return dbObserver.getEntities()
    }

}

public protocol CategoryRepository {
    func getCategories() -> [Categorys]
}
