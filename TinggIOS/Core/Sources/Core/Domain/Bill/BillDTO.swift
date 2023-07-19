//
//  File.swift
//  
//
//  Created by Abdulrasaq on 12/09/2022.
//

import Foundation
// MARK: - SaveBillDTO
public struct BillDTO: BaseDTOprotocol, Codable {
    public var statusCode: Int
    public var statusMessage: String
    public var savedBill: [Bill] = .init()
    public init(statusCode: Int, statusMessage: String, savedBill: [Bill]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.savedBill = savedBill
    }
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case savedBill = "RESULT_ARRAY"
    }
}

// MARK: - SavedBill
public class Bill: NSObject, Codable, BaseDTOprotocol {
    public var statusCode: Int = 0
    public var manualBillID: DynamicType?
    public var statusMessage: String = ""
    public var clientProfileAccountID: String = ""
    public var merchantAccountNumber: String = ""
    public var merchantAccountName: String = ""
    public var merchantServiceID: String = ""
    public var accountAlias: String = ""
    public var isExplicit: DynamicType?
    public var active: Int = 0
    public var insertedBy: Int = 0
    public var dateCreated: String = ""
    public var dateModified: String = ""
    public var billAmount: Int = 0

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case manualBillID = "MANUAL_BILL_ID"
        case statusMessage = "STATUS_MESSAGE"
        case clientProfileAccountID, merchantAccountNumber, merchantAccountName, merchantServiceID, accountAlias, isExplicit, active, insertedBy, dateCreated, dateModified
    }
}


public extension Bill {
    func convertBillToEnrollment(accountNumber: String, service: MerchantService) -> Enrollment {
        let enrollment = Enrollment()
        enrollment.accountAlias = self.accountAlias
        enrollment.clientProfileAccountID = Int(self.clientProfileAccountID) ?? 0
        enrollment.isExplicit = self.isExplicit?.toBool ?? false
        enrollment.accountID = self.clientProfileAccountID
        enrollment.accountStatus = self.active
        enrollment.accountNumber = accountNumber
        enrollment.serviceName = service.serviceName
        enrollment.serviceLogo = service.serviceLogo
        enrollment.hubServiceID = Int(service.hubServiceID) ?? 0
        enrollment.serviceCode = service.serviceCode
        enrollment.accountName = self.merchantAccountName
        enrollment.accountAlias = self.accountAlias
        return enrollment
    }
}



// MARK: - FetchedBill
class FetchedBills {
    let billDescription, billReference, biller, serviceID: String
    let customerName, invoiceNumber: String
    let amount: Int
    let currency, dueDate, beepTransactionID, parkingZone: String
    let vehicleType, callbackData, currentAppVersion: String
    let isEstimate, estimateAmount: Int
    let dateEstimated, estimateExpiryDate, lastFetchDate, expiryDate: String

    init(billDescription: String, billReference: String, biller: String, serviceID: String, customerName: String, invoiceNumber: String, amount: Int, currency: String, dueDate: String, beepTransactionID: String, parkingZone: String, vehicleType: String, callbackData: String, currentAppVersion: String, isEstimate: Int, estimateAmount: Int, dateEstimated: String, estimateExpiryDate: String, lastFetchDate: String, expiryDate: String) {
        self.billDescription = billDescription
        self.billReference = billReference
        self.biller = biller
        self.serviceID = serviceID
        self.customerName = customerName
        self.invoiceNumber = invoiceNumber
        self.amount = amount
        self.currency = currency
        self.dueDate = dueDate
        self.beepTransactionID = beepTransactionID
        self.parkingZone = parkingZone
        self.vehicleType = vehicleType
        self.callbackData = callbackData
        self.currentAppVersion = currentAppVersion
        self.isEstimate = isEstimate
        self.estimateAmount = estimateAmount
        self.dateEstimated = dateEstimated
        self.estimateExpiryDate = estimateExpiryDate
        self.lastFetchDate = lastFetchDate
        self.expiryDate = expiryDate
    }
}
