//
//  TransactionHistory.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//

import Foundation
// MARK: - TransactionHistory
public class TransactionHistory: Identifiable, Codable {
    public let beepTransactionID: String?
    public let amount, billAmount: Int
    public let status, transactionTitle, currencyCode, accountNumber: String?
    public let serviceID, shortDescription, msisdn, bundleID: String?
    public let message, requestLogID, narration, dateCreated: String?
    public let statusCode, payerClientID, invoiceNumber, token: String?
    public let merchantService: MerchantService?
    public let merchantPayer: MerchantPayer?
    public let transferType: String?
    public static let STATUS_PENDING = "Pending"
    public static let STATUS_SUCCESS = "Success"
    public static let STATUS_FAILED = "Failed"
    public static let STATUS_EXPIRED = "Expired"
    public static let STATUS_REFUND = "Refund"
    public static let STATUS_REFUNDED = "Refunded"
    public static let STATUS_REVERSAL = "Reversal"
    public static let STATUS_REVERSED = "Reversed"
    public static let STATUS_ORDER = "Order"
    public static let STATUS_PAYMENT_ACCEPTED = "Payment accepted"
    public static let STATUS_PAYMENT_REJECTED = "Payment rejected"
    public static let SUCCESS_CODE_217 = "217"
    public static let SUCCESS_CODE_140 = "140"
    
    enum CodingKeys: String, CodingKey {
        case beepTransactionID, amount, billAmount, status, transactionTitle, currencyCode, accountNumber, serviceID, shortDescription
        case msisdn = "MSISDN"
        case bundleID = "BUNDLE_ID"
        case message, requestLogID, narration, dateCreated, statusCode, payerClientID, invoiceNumber, token, merchantService, merchantPayer, transferType
    }
    
    init(beepTransactionID: String?, amount: Int, billAmount: Int, status: String?, transactionTitle: String?, currencyCode: String?, accountNumber: String?, serviceID: String?, shortDescription: String?, msisdn: String?, bundleID: String?, message: String?, requestLogID: String?, narration: String?, dateCreated: String?, statusCode: String?, payerClientID: String?, invoiceNumber: String?, token: String?, merchantService: MerchantService?, merchantPayer: MerchantPayer?, transferType: String?) {
        self.beepTransactionID = beepTransactionID
        self.amount = amount
        self.billAmount = billAmount
        self.status = status
        self.transactionTitle = transactionTitle
        self.currencyCode = currencyCode
        self.accountNumber = accountNumber
        self.serviceID = serviceID
        self.shortDescription = shortDescription
        self.msisdn = msisdn
        self.bundleID = bundleID
        self.message = message
        self.requestLogID = requestLogID
        self.narration = narration
        self.dateCreated = dateCreated
        self.statusCode = statusCode
        self.payerClientID = payerClientID
        self.invoiceNumber = invoiceNumber
        self.token = token
        self.merchantService = merchantService
        self.merchantPayer = merchantPayer
        self.transferType = transferType
    }
}
