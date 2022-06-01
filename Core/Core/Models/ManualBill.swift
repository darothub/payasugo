//
//  ManualBill.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation
public class ManualBill : Identifiable, Codable {
    public let id: String = ""
    public let accountNumber: String? = nil
    public let merchantAccountName: String? = nil
    public let paymentFrequency: String? = nil
    public let amount: String? = nil
    public let payerOptions: [PayerOptions]? = nil
    public let billDueDate: String? = nil
    public let manualBillType: String? = nil
    public let categoryId: String? = ""
    public let accountPayload: String? = nil
    public let category: Category? = nil
    enum CodingKeys: String, CodingKey {
        case id = "MANUAL_BILL_ID"
        case accountNumber = "MERCHANT_ACCOUNT_NUMBER"
        case merchantAccountName = "MERCHANT_NAME"
        case paymentFrequency = "BILL_REMINDER_FREQUENCY"
        case amount = "BILL_AMOUNT"
        case payerOptions = "PAYMENT_OPTIONS"
        case billDueDate = "BILL_DUE_DATE"
        case manualBillType = "IS_BILL_SEARCH"
        case categoryId = "CATEGORY_ID"
        case accountPayload = "accountPayload"
        case category = " category_"
    }
}
