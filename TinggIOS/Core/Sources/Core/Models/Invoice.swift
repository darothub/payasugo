//
//  Invoice.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - Invoice
public class Invoice: Object, DBObject, ObjectKeyIdentifiable, Codable {
    @Persisted public var billDescription: String = ""
    @Persisted(primaryKey: true) public var billReference: String = ""
    @Persisted public var biller: String = ""
    @Persisted public var serviceID: String = ""
    @Persisted public var customerName: String = ""
    @Persisted public var invoiceNumber: String = ""
    @Persisted public var amount: String = ""
    @Persisted public var currency: String = ""
    @Persisted public var dueDate: String = ""
    @Persisted public var beepTransactionID: String = ""
    @Persisted public var parkingZone: String = ""
    @Persisted public var vehicleType: String = ""
    @Persisted public var callbackData: String = ""
    @Persisted public var currentAppVersion: String = ""
    @Persisted public var isEstimate: Int = 0
    @Persisted public var estimateAmount: Int = 0
    @Persisted public var dateEstimated: String = ""
    @Persisted public var estimateExpiryDate: String = ""
    @Persisted public var lastFetchDate: String = ""
//    @Persisted public var enrollment: Enrollment? = nil
//    public var statusCode: Int = 0
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

public var sampleInvoice : Invoice {
    let invoice = Invoice()
    invoice.customerName = "DANIEL KIMANI"
    invoice.biller = "GOTVKE"
    invoice.billReference = "2014183174"
    invoice.serviceID = "2"
    invoice.currency = "KES"
    invoice.dueDate = "2022-11-11"
    invoice.amount = "930"
    return invoice
}

public var sampleInvoice2: Invoice {
    let invoice = Invoice()
    invoice.customerName = "DANIEL KIMANI"
    invoice.biller = "GOTVKE"
    invoice.billReference = "2014183175"
    invoice.serviceID = "2"
    invoice.currency = "KES"
    invoice.dueDate = "2022-11-11"
    invoice.amount = "930"
    return invoice
}

public var sampleInvoices: [Invoice] {
    return [sampleInvoice, sampleInvoice2]
}
