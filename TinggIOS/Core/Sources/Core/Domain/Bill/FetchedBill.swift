//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation

// MARK: - FetchedBill
public class FetchedBill: Codable {
    let billDescription, billReference, biller: String
    let serviceID: Int
    let customerName, invoiceNumber: String
    let amount: Int
    let currency, dueDate, beepTransactionID, expiryDate: String

    enum CodingKeys: String, CodingKey {
        case billDescription = "BILL_DESCRIPTION"
        case billReference = "BILL_REFERENCE"
        case biller = "BILLER"
        case serviceID = "SERVICE_ID"
        case customerName = "CUSTOMER_NAME"
        case invoiceNumber = "INVOICE_NUMBER"
        case amount = "AMOUNT"
        case currency = "CURRENCY"
        case dueDate = "DUE_DATE"
        case beepTransactionID = "BEEP_TRANSACTION_ID"
        case expiryDate = "EXPIRY_DATE"
    }
}
