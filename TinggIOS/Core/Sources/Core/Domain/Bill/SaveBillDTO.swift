//
//  File.swift
//  
//
//  Created by Abdulrasaq on 12/09/2022.
//

import Foundation
// MARK: - SaveBillDTO
public struct SaveBillDTO: BaseDTOprotocol, Codable {
    public var statusCode: Int
    public var statusMessage: String
    public var savedBill: [SavedBill]
    public init(statusCode: Int, statusMessage: String, savedBill: [SavedBill]) {
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
public class SavedBill: NSObject, Codable {
    public var statusCode: Int = 0
    public var manualBillID: String = ""
    public var statusMessage: String = ""
    public var clientProfileAccountID: String = ""
    public var merchantAccountNumber: String = ""
    public var merchantAccountName: String = ""
    public var merchantServiceID: String = ""
    public var accountAlias: String = ""
    public var isExplicit: String = ""
    public var active: Int = 0
    public var insertedBy: Int = 0
    public var dateCreated: String = ""
    public var dateModified: String = ""
    public var billAmount: Int = 0

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
//        case manualBillID = "MANUAL_BILL_ID"
        case statusMessage = "STATUS_MESSAGE"
        case clientProfileAccountID, merchantAccountNumber, merchantAccountName, merchantServiceID, accountAlias, isExplicit, active, insertedBy, dateCreated, dateModified
    }
}


extension SavedBill {
    func convertBillToEnrollment(accountNumber: String) -> Enrollment {
        let enrollment = Enrollment()
        enrollment.accountAlias = self.accountAlias
        enrollment.clientProfileAccountID = Int(self.clientProfileAccountID) ?? 0
        enrollment.isExplicit = self.isExplicit
        enrollment.accountID = self.clientProfileAccountID
        enrollment.accountStatus = self.active
        enrollment.accountNumber = accountNumber
        return enrollment
    }
}
