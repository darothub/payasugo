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
    var dbObserver: Observer<Categorys>
    let realm: RealmManager = .init()
    public init(dbObserver: Observer<Categorys>) {
        self.dbObserver = dbObserver
        saveDataInDB()
    }
  
    public func getCategories() -> [Categorys] {
        return dbObserver.getEntities()
    }
    
    func saveDataInDB() {
        let category1 = Categorys()
        category1.categoryID = "1"
        let category2 = Categorys()
        category2.categoryID = "2"
        let category3 = Categorys()
        category3.categoryID = "3"
        let category4 = Categorys()
        category4.categoryID = "4"
        let data = [category1, category2, category3, category4]
        realm.save(data: data)
    }
}
