//
//  TransactionSectionModel.swift
//  
//
//  Created by Abdulrasaq on 17/04/2023.
//

import Foundation
public struct TransactionSectionModel: Identifiable, Comparable {
    public static func < (lhs: TransactionSectionModel, rhs: TransactionSectionModel) -> Bool {
        if lhs.list.isNotEmpty() && rhs.list.isNotEmpty() {
            return lhs.list[0].date > rhs.list[0].date
        } else { return false }
    }
    
    public var id = UUID().description
    public var list = [TransactionItemModel.sample, TransactionItemModel.sample2]
    public var header: String {
        let h = ""
        if list.isNotEmpty() {
           return list[0].date.formatted(with: "EEEE, dd MMMM yyyy")
        }
        return h
    }
    
    public init(id: String = UUID().description, list: [TransactionItemModel] = [TransactionItemModel.sample, TransactionItemModel.sample2]) {
        self.id = id
        self.list = list
    }
    public static var sample = TransactionSectionModel()
    public static var sample2 = TransactionSectionModel()
}
