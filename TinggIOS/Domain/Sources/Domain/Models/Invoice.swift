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
public class Invoice: Object, ObjectKeyIdentifiable, Codable {
    @Persisted public var currency: String? = ""
    @Persisted public var dueDate: String? = ""
    @Persisted public var parkingZone: String? = ""
    @Persisted public var callbackData: String? = ""
    @Persisted public var beepTransactionID: String? = ""
    @Persisted public var invoiceNumber: String? = ""
    @Persisted public var vehicleType: String? = ""
    @Persisted public var expiryDate: String? = ""
    @Persisted public var billReference: String? = ""
    @Persisted public var customerName: String? = ""
    @Persisted public var amount:Int = 0
    @Persisted public var partialPaidAmount: Int = 0
    @Persisted public var fullyPaid:Bool = false
    @Persisted public var overPaid: Bool = false
    @Persisted public var serviceID: String? = ""
    @Persisted public var billDescription: String? = ""
    @Persisted public var biller: String? = ""
    @Persisted public var statusCode: Int = 0
    @Persisted public var hasPaymentInProgress:Bool
    @Persisted public var isFetchingBill: Bool
    @Persisted public var enrollment: Enrollment?
    @Persisted public var estimate: String? = ""
    @Persisted public var statusPaymentInProgress: String? = ""
    @Persisted public var statusDue: String? = ""

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
//    init(
//        currency: String?, dueDate: String?,
//        parkingZone: String?, callbackData: String?, beepTransactionID: String?,
//        invoiceNumber: String?, vehicleType: String?, expiryDate: String?,
//        billReference: String?, customerName: String?, amount: Int,
//        partialPaidAmount: Int, fullyPaid: Bool, overPaid: Bool,
//        serviceID: String?, billDescription: String?, biller: String?,
//        statusCode: Int, hasPaymentInProgress: Bool, isFetchingBill: Bool,
//        enrollment: Enrollment, estimate: String?, statusPaymentInProgress: String?,
//        statusDue: String?
//    ) {
//        self.currency = currency
//        self.dueDate = dueDate
//        self.parkingZone = parkingZone
//        self.callbackData = callbackData
//        self.beepTransactionID = beepTransactionID
//        self.invoiceNumber = invoiceNumber
//        self.vehicleType = vehicleType
//        self.expiryDate = expiryDate
//        self.billReference = billReference
//        self.customerName = customerName
//        self.amount = amount
//        self.partialPaidAmount = partialPaidAmount
//        self.fullyPaid = fullyPaid
//        self.overPaid = overPaid
//        self.serviceID = serviceID
//        self.billDescription = billDescription
//        self.biller = biller
//        self.statusCode = statusCode
//        self.hasPaymentInProgress = hasPaymentInProgress
//        self.isFetchingBill = isFetchingBill
//        self.enrollment = enrollment
//        self.estimate = estimate
//        self.statusPaymentInProgress = statusPaymentInProgress
//        self.statusDue = statusDue
//    }
}
