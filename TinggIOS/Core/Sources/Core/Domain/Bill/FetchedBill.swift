//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation

// MARK: - FetchedBill
/// Type for Fetched Bill
public class FetchedBill: NSObject, Codable {
    public var billDescription: String = ""
    public var billReference: String = ""
    public var biller: String = ""
    public var serviceID: String = ""
    public var customerName: String = ""
    public var invoiceNumber: String = ""
    public var amount: String = ""
    public var currency: String = ""
    public var dueDate: String = ""
    public var beepTransactionID: String = ""
    public var parkingZone: String = ""
    public var vehicleType: String = ""
    public var callbackData: String = ""
    public var currentAppVersion: String = ""
    public var isEstimate: Int = 0
    public var estimateAmount: Int = 0
    public var dateEstimated: String = ""
    public var estimateExpiryDate: String = ""
    public var lastFetchDate: String = ""
//    public var statusCode: Int = 0
    
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
//        case statusCode = "STATUS_CODE"
    }
}


