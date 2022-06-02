//
//  Bank.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//

import Foundation

// MARK: - Bank
class Bank: Identifiable, Codable {
    public let id, accountNumber, accountName, bankName: String
    public let bankBranch: String
    public let selected: Bool
    public static let tag: String = "Bank"

    enum CodingKeys: String, CodingKey {
        case id, accountNumber, accountName, bankName, bankBranch, selected
    }

    init( id: String, accountNumber: String, accountName: String, bankName: String, bankBranch: String, selected: Bool) {
        self.id = id
        self.accountNumber = accountNumber
        self.accountName = accountName
        self.bankName = bankName
        self.bankBranch = bankBranch
        self.selected = selected
    }
}
