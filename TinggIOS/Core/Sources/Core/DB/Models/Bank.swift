//
//  Bank.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//
// swiftlint:disable all
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
}
