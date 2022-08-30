//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation

// MARK: - FetchedBill
public struct FetchedBill: Codable {
    public let billDescription, billReference, biller, serviceID: String
    public let customerName, invoiceNumber: String
    //     public let amount: Int
    public let currency, dueDate, beepTransactionID, parkingZone: String
    public let vehicleType, callbackData, currentAppVersion: String
    public let isEstimate, estimateAmount: Int
    public let dateEstimated, estimateExpiryDate, lastFetchDate: String
    public let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case billDescription = "BILL_DESCRIPTION"
        case billReference = "BILL_REFERENCE"
        case biller = "BILLER"
        case serviceID = "SERVICE_ID"
        case customerName = "CUSTOMER_NAME"
        case invoiceNumber = "INVOICE_NUMBER"
        //        case amount = "AMOUNT"
        case currency = "CURRENCY"
        case dueDate = "DUE_DATE"
        case beepTransactionID = "BEEP_TRANSACTION_ID"
        case parkingZone = "PARKING_ZONE"
        case vehicleType = "VEHICLE_TYPE"
        case callbackData = "CALLBACK_DATA"
        case currentAppVersion = "CURRENT_APP_VERSION"
        case isEstimate = "IS_ESTIMATE"
        case estimateAmount = "ESTIMATE_AMOUNT"
        case dateEstimated = "DATE_ESTIMATED"
        case estimateExpiryDate = "ESTIMATE_EXPIRY_DATE"
        case lastFetchDate = "LAST_FETCH_DATE"
        case statusCode = "STATUS_CODE"
    }
}
