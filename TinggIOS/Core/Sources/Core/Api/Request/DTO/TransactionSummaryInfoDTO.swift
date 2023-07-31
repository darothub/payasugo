//
//  TransactionSummaryInfoDTO.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation
// MARK: - TransactionSummaryInfoDTO
public struct TransactionSummaryInfoDTO: Codable {
    public let statusCode, payerTransactionID, beepTransactionID, receiptNumber: DynamicType
    public let receiverNarration: DynamicType
    public let function: DynamicType
    public let serviceCode: DynamicType
    public let paymentDate: DynamicType
    public let clientCode: DynamicType
    public let dateCreated, amount: DynamicType
    public let requestOrigin: DynamicType
    public let accountNumber, serviceID: DynamicType
    public let currencyCode: DynamicType
    public let payerClientID: DynamicType
    public let serviceName: DynamicType
    public let shortDescription: DynamicType
    public let msisdn: DynamicType
    public let status: Status
    public let serviceLogo: DynamicType
    public let transferType: TransferType?

    enum CodingKeys: String, CodingKey {
        case statusCode, payerTransactionID, beepTransactionID, receiptNumber, receiverNarration, function, serviceCode, paymentDate, clientCode, dateCreated, amount, requestOrigin, accountNumber, serviceID, currencyCode, payerClientID, serviceName, shortDescription
        case msisdn = "MSISDN"
        case status, serviceLogo, transferType
    }
    public var toEntity: TransactionHistory {
        var entity = TransactionHistory()
        entity.statusCode = self.statusCode.toString
        entity.payerTransactionID = self.payerTransactionID.toString
        entity.beepTransactionID = self.beepTransactionID.toString
        entity.receiptNumber = self.receiptNumber.toString
        entity.receiverNarration = self.receiverNarration.toString
        entity.function = self.function.toString
        entity.serviceCode = self.serviceCode.toString
        entity.paymentDate = self.paymentDate.toString
        entity.clientCode = self.clientCode.toString
        entity.dateCreated = self.dateCreated.toString
        entity.amount = self.amount.toString
        entity.requestOrigin = self.requestOrigin.toString
        entity.accountNumber = self.accountNumber.toString
        entity.serviceID = self.serviceID.toString
        entity.currencyCode = self.currencyCode.toString
        entity.payerClientID = self.payerClientID.toString
        entity.serviceName = self.serviceName.toString
        entity.shortDescription = self.shortDescription.toString
        entity.msisdn = self.msisdn.toString
        entity.status = self.status.rawValue
        entity.serviceLogo = self.serviceLogo.toString
        entity.transferType = self.transferType?.rawValue
        return entity
    }
}
