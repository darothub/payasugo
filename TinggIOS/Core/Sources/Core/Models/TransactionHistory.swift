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
public class TransactionHistory: Object, DBObject, ObjectKeyIdentifiable, Codable {
    @Persisted public var id: ObjectId
    @Persisted public var statusCode : String?
    @Persisted(primaryKey: true) public var payerTransactionID : String?
    @Persisted public var beepTransactionID : String?
    @Persisted public var receiptNumber: String?
    @Persisted public var receiverNarration: String?
    @Persisted public var function: String?
    @Persisted public var serviceCode: String?
    @Persisted public var paymentDate: String?
    @Persisted public var clientCode: String?
    @Persisted public var dateCreated: String?
    @Persisted public var amount: String?
    @Persisted public var requestOrigin: String?
    @Persisted public var accountNumber: String?
    @Persisted public var serviceID: String?
    @Persisted public var currencyCode: String?
    @Persisted public var payerClientID: String
    @Persisted public var serviceName: String?
    @Persisted public var shortDescription: String?
    @Persisted public var msisdn: String?
    @Persisted public var status: String?
    @Persisted public var token: String?
    @Persisted public var units: String?
    @Persisted public var serviceLogo: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode, payerTransactionID, beepTransactionID,
             receiptNumber, receiverNarration, function,
             serviceCode, paymentDate, clientCode, dateCreated, amount,
             requestOrigin, accountNumber, serviceID, currencyCode,
             payerClientID, serviceName, shortDescription
        case msisdn = "MSISDN"
        case status, token, units, serviceLogo
    }
    
}
