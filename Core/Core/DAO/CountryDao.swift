//
//  CountryDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol CountryDao {
    func getActiveLive() -> ObservedResults<Country>
    func getActive() -> Country
    func getAllLive() -> ObservedResults<Country>
    func countAll() -> Int
    func clearActive()
}
