//
//  SecurityQuestionDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol SecurityQuestionDao {
    func getAllLive() -> ObservedResults<SecurityQuestion>
    func findQuestionId(question: String) -> Int
    func deleteAll()
}
