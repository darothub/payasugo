//
//  SyncDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
protocol SyncDao {
    func getLast() -> Sync?
}