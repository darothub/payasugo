//
//  File.swift
//  
//
//  Created by Abdulrasaq on 17/04/2023.
//

import Foundation

public struct TransactionItemModel: Identifiable, Comparable, Hashable {
    public static func < (lhs: TransactionItemModel, rhs: TransactionItemModel) -> Bool {
        lhs.date < rhs.date
    }
    
    public var id = UUID().description
    public var imageurl: String = ""
    public var accountName = "George"
    public var accountNumber: String = "000000"
    public var date: Date = .distantPast
    public var amount: Double = 72.3
    public var currency: String = AppStorageManager.getCountry()?.currency ?? "KES"
    public var payer: MerchantPayer = .init()
    public var service: MerchantService = sampleServices[0]
    public var status: TransactionStatus = .pending
    
    public init(id: String = UUID().description, imageurl: String = "", accountName: String = "George", accountNumber: String = "000000", date: Date = .distantPast, amount: Double = 72.3, currency: String = AppStorageManager.getCountry()?.currency ?? "KES", payer: MerchantPayer = .init(), service: MerchantService = .init(), status: TransactionStatus = .pending) {
        self.id = id
        self.imageurl = imageurl
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.date = date
        self.amount = amount
        self.currency = currency
        self.payer = payer
        self.service = service
        self.status = status
    }
    
    public static var sample = TransactionItemModel()
    public static var sample2 = TransactionItemModel(date: Date.distantPast)
    
}


