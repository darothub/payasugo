//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public class CategoryRepositoryImpl: CategoryRepository {
    private var dbObserver: Observer<Categorys>
    /// Category repository initialiser
    /// - Parameter dbObserver: an instance of ``Observer``
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
