//
//  Invoice.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation
// MARK: - Invoice
public class Invoice: Identifiable, Codable {
    public let currency, dueDate, parkingZone, callbackData: String?
    public let beepTransactionID, invoiceNumber, vehicleType, expiryDate: String?
    public let billReference, customerName: String?
    public let amount, partialPaidAmount: Int
    public let fullyPaid, overPaid: Bool
    public let serviceID, billDescription, biller: String?
    public let statusCode: Int
    public let hasPaymentInProgress, isFetchingBill: Bool
    public let enrollment: Enrollment?
    public let estimate, statusPaymentInProgress, statusDue: String?

    enum CodingKeys: String, CodingKey {
        case currency = "CURRENCY"
        case dueDate = "DUE_DATE"
        case parkingZone = "PARKING_ZONE"
        case callbackData = "CALLBACK_DATA"
        case beepTransactionID = "BEEP_TRANSACTION_ID"
        case invoiceNumber = "INVOICE_NUMBER"
        case vehicleType = "VEHICLE_TYPE"
        case expiryDate = "EXPIRY_DATE"
        case billReference = "BILL_REFERENCE"
        case customerName = "CUSTOMER_NAME"
        case amount = "AMOUNT"
        case partialPaidAmount, fullyPaid, overPaid
        case serviceID = "SERVICE_ID"
        case billDescription = "BILL_DESCRIPTION"
        case biller = "BILLER"
        case statusCode = "STATUS_CODE"
        case hasPaymentInProgress, isFetchingBill, enrollment
        case estimate = "ESTIMATE"
        case statusPaymentInProgress = "STATUS_PAYMENT_IN_PROGRESS"
        case statusDue = "STATUS_DUE"
    }

    init(currency: String?, dueDate: String?, parkingZone: String?, callbackData: String?, beepTransactionID: String?, invoiceNumber: String?, vehicleType: String?, expiryDate: String?, billReference: String?, customerName: String?, amount: Int, partialPaidAmount: Int, fullyPaid: Bool, overPaid: Bool, serviceID: String?, billDescription: String?, biller: String?, statusCode: Int, hasPaymentInProgress: Bool, isFetchingBill: Bool, enrollment: Enrollment, estimate: String?, statusPaymentInProgress: String?, statusDue: String?) {
        self.currency = currency
        self.dueDate = dueDate
        self.parkingZone = parkingZone
        self.callbackData = callbackData
        self.beepTransactionID = beepTransactionID
        self.invoiceNumber = invoiceNumber
        self.vehicleType = vehicleType
        self.expiryDate = expiryDate
        self.billReference = billReference
        self.customerName = customerName
        self.amount = amount
        self.partialPaidAmount = partialPaidAmount
        self.fullyPaid = fullyPaid
        self.overPaid = overPaid
        self.serviceID = serviceID
        self.billDescription = billDescription
        self.biller = biller
        self.statusCode = statusCode
        self.hasPaymentInProgress = hasPaymentInProgress
        self.isFetchingBill = isFetchingBill
        self.enrollment = enrollment
        self.estimate = estimate
        self.statusPaymentInProgress = statusPaymentInProgress
        self.statusDue = statusDue
    }
}
