//
//  Bank.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//

import Foundation
import RealmSwift

// MARK: - Bank
struct Bank: Codable {
    var id:String?
    var accountNumber:String?
    var accountName:String?
    var bankName:String?
    var bankBranch: String
    var selected: Bool
    public static let tag: String = "Bank"

    enum CodingKeys: String, CodingKey {
        case id, accountNumber, accountName, bankName, bankBranch, selected
    }

//    init( id: String, accountNumber: String, accountName: String, bankName: String, bankBranch: String, selected: Bool) {
//        self.id = id
//        self.accountNumber = accountNumber
//        self.accountName = accountName
//        self.bankName = bankName
//        self.bankBranch = bankBranch
//        self.selected = selected
//    }
}
