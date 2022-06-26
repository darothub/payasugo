//
//  BaseDao.swift
//  Core
//
//  Created by Abdulrasaq on 07/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
protocol BaseDao {
    associatedtype T: RealmCollectionValue
    func insert(item: T)
    func remove(item: T)
}
