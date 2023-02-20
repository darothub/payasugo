//
//  RINVResponse.swift
//
//
//  Created by Abdulrasaq on 16/02/2023.
//

import Core
import Foundation

// MARK: - RINVResponse
public struct RINVResponse: BaseDTOprotocol {
    public let statusCode: Int
    public let statusMessage: String
    public let raisedInvoice: [RaisedInvoice]
    public let stkLauncherParameters: [StkLauncherParameter]
    public init(statusCode: Int, statusMessage: String, raisedInvoice: [RaisedInvoice], stkLauncherParameters: [StkLauncherParameter]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.raisedInvoice = raisedInvoice
        self.stkLauncherParameters = stkLauncherParameters
    }
    enum CodingKeys: String, CodingKey {
          case statusCode = "STATUS_CODE"
          case statusMessage = "STATUS_MESSAGE"
          case raisedInvoice = "RAISED_INVOICE"
          case stkLauncherParameters = "STK_LAUNCHER_PARAMETERS"
    }
}

// MARK: - RaisedInvoice
public struct RaisedInvoice: Decodable {
    let invoiceNumber, beepTransactionID: Int
    let accountNumber, amount: String
    public init(invoiceNumber: Int, beepTransactionID: Int, accountNumber: String, amount: String) {
        self.invoiceNumber = invoiceNumber
        self.beepTransactionID = beepTransactionID
        self.accountNumber = accountNumber
        self.amount = amount
    }
    enum CodingKeys: String, CodingKey {
        case invoiceNumber = "INVOICE_NUMBER"
        case beepTransactionID = "BEEP_TRANSACTION_ID"
        case accountNumber = "ACCOUNT_NUMBER"
        case amount = "AMOUNT"
    }
}

// MARK: - StkLauncherParameter
public struct StkLauncherParameter: Decodable {
    let label: String
    let value: Value
    public init(label: String, value: Value) {
        self.label = label
        self.value = value
    }
}

public enum Value: Codable {
    case integer(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Value.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
