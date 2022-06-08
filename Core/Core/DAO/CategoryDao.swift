//
//  CategoryDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol CategoryDao {
     func findById(id: String?)-> Category?
     func getAllActiveLive() -> ObservedResults<Category>
}
