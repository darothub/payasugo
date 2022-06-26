//
//  HighlightDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift
protocol HighlightDao {
    func getAllActiveLive()-> ObservedResults<Highlight>
    func getAll()-> List<Highlight>
    func getAllActiveWithServiceIdNotIn(vararg ids: String?)-> List<Highlight?>?
    func deleteAll()
}
