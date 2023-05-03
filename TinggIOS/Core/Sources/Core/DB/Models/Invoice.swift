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
    @Persisted public var enrollment: Enrollment? = nil
    @Persisted public var hasPaymentInProgress: Bool = false
    @Persisted public var partialPaidAmount: Double = 0.0
    @Persisted public var fullyPaid = false
    @Persisted public var overPaid = false
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


public protocol Flexible: Decodable {
    func convert<Output: Decodable>(to output: Output.Type) -> Output
}

public struct Flex<Value: Decodable, AltValue: Flexible>: Decodable {
    public let value: Value
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Value.self) {
            self.value = value
        } else {
            let altValue = try container.decode(AltValue.self)
            self.value = altValue.convert(to: Value.self)
        }
    }
}


extension Int: Flexible {
    public func convert<Output: Decodable>(to output: Output.Type) -> Output {
        switch output {
        case is String.Type:
            return String(self) as! Output
        default:
            fatalError()
        }
    }
}
extension Int?: Flexible {
    public func convert<Output: Decodable>(to output: Output.Type) -> Output {
        switch output {
        case is String.Type:
            return String(self ?? 0) as! Output
        default:
            fatalError()
        }
    }
}

extension String: Flexible {
    public func convert<Output: Decodable>(to output: Output.Type) -> Output {
        switch output {
        case is Int.Type:
            return Int("0") as! Output
        default:
            fatalError()
        }
    }
}

public struct DynamicInvoiceType: Decodable   {
     public var billDescription: String = ""
     public var billReference: String = ""
     public var biller: String = ""
     public var serviceID: String = ""
     public var customerName: String = ""
     public var invoiceNumber: String = ""
     public var amount: StringOrIntEnum
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
     public var enrollment: Int? = 0
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
    
    func convertToInvoice() -> Invoice {
        let invoice = Invoice()
        invoice.billReference = self.billReference
        invoice.billDescription = self.billDescription
        invoice.beepTransactionID = self.beepTransactionID
        invoice.amount = self.amount.toString
        invoice.biller = self.biller
        invoice.serviceID = self.serviceID
        invoice.customerName = self.customerName
        invoice.invoiceNumber = self.invoiceNumber
        invoice.currency = self.currency
        invoice.dueDate = self.dueDate
        invoice.callbackData = self.callbackData
        invoice.vehicleType = self.vehicleType
        invoice.parkingZone = self.parkingZone
        invoice.currentAppVersion = self.currentAppVersion
        invoice.isEstimate = self.isEstimate
        invoice.estimateAmount = self.estimateAmount
        invoice.dateEstimated = self.dateEstimated
        invoice.estimateExpiryDate = self.estimateExpiryDate
        invoice.lastFetchDate = self.lastFetchDate
        return invoice
    }
    
}

