//
//  TransactionHistory.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - TransactionHistory
public class TransactionHistory: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var beepTransactionID: String = ""
    @Persisted public var amount:String? = ""
    @Persisted public var billAmount: Int? = 0
    @Persisted public var status:String? = ""
    @Persisted public var transactionTitle:String? = ""
    @Persisted public var currencyCode:String? = ""
    @Persisted public var accountNumber: String? = ""
    @Persisted public var serviceID: String? = ""
    @Persisted public var shortDescription: String? = ""
    @Persisted public var msisdn: String? = ""
    @Persisted public var bundleID: String? = ""
    @Persisted public var message: String? = ""
    @Persisted public var requestLogID: String? = ""
    @Persisted public var narration: String? = ""
    @Persisted public var dateCreated: String? = ""
    @Persisted public var statusCode: String? = ""
    @Persisted public var payerClientID: String? = ""
    @Persisted public var invoiceNumber: String? = ""
    @Persisted public var token: String? = ""
    @Persisted public var merchantService: MerchantService? = nil
    @Persisted public var merchantPayer: MerchantPayer? = nil
    @Persisted public var transferType: String?
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
        case beepTransactionID,
             amount,
             billAmount,
             status,
             transactionTitle,
             currencyCode,
             accountNumber,
             serviceID,
             shortDescription
        case msisdn = "MSISDN"
        case bundleID = "BUNDLE_ID"
        case message,
             requestLogID,
             narration,
             dateCreated,
             statusCode,
             payerClientID,
             invoiceNumber,
             token,
             merchantService,
             merchantPayer,
             transferType
    }

}
