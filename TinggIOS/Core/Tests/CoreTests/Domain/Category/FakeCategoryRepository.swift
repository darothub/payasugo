//
//  File.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//

import Foundation
import Core
import RealmSwift
class FakeCategoryRepository: CategoryRepository {
    var dbObserver: Observer<CategoryEntity>
    let realm: RealmManager = .init()
    public init(dbObserver: Observer<CategoryEntity>) {
        self.dbObserver = dbObserver
        saveDataInDB()
    }
  
    public func getCategories() -> [CategoryEntity] {
        return dbObserver.getEntities()
    }
    
    func saveDataInDB() {
        let category1 = CategoryEntity()
        category1.categoryID = "1"
        category1.categoryName = "Airtime"
        let category2 = CategoryEntity()
        category2.categoryID = "2"
        category2.categoryName = "PayTV"
        let category3 = CategoryEntity()
        category3.categoryID = "3"
        category3.categoryName = "Power"
        let category4 = CategoryEntity()
        category4.categoryID = "4"
        category4.categoryName = "Water"
        let data = [category1, category2, category3, category4]
        realm.save(data: data)
    }
}
