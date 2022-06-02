//
//  ManualBill.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation

// MARK: - ManualBil
public class ManualBil: Codable {
    public let manualBillID, merchantAccountNumber, merchantName, billReminderFrequency: String?
    public let billAmount: String?
    public let paymentOptions: [PayerOptions]?
    public let billDueDate, isBillSearch, categoryID, accountPayload: String?
    public let category: Category?
//    public static let PARKING_ID = "24"
//    public static let PAY_TV_ID = "1"
//    public static let POWER_ID = "10"
//    public static let INTERNET_ID = "14"
//    public static let WATER_ID = "11"
//    public static let AIRTIME_ID = "2"
//    public static let GAS_ID = "22"
//    public static let OTHER_ID = "8"
//    public static let INVEST_ID = "4"

    enum CodingKeys: String, CodingKey {
        case manualBillID = "MANUAL_BILL_ID"
        case merchantAccountNumber = "MERCHANT_ACCOUNT_NUMBER"
        case merchantName = "MERCHANT_NAME"
        case billReminderFrequency = "BILL_REMINDER_FREQUENCY"
        case billAmount = "BILL_AMOUNT"
        case paymentOptions = "PAYMENT_OPTIONS"
        case billDueDate = "BILL_DUE_DATE"
        case isBillSearch = "IS_BILL_SEARCH"
        case categoryID = "CATEGORY_ID"
        case accountPayload, category
    }

    init(manualBillID: String?, merchantAccountNumber: String?, merchantName: String?, billReminderFrequency: String?, billAmount: String?, paymentOptions: [PayerOptions]?, billDueDate: String?, isBillSearch: String?, categoryID: String?, accountPayload: String?, category: Category?) {
        self.manualBillID = manualBillID
        self.merchantAccountNumber = merchantAccountNumber
        self.merchantName = merchantName
        self.billReminderFrequency = billReminderFrequency
        self.billAmount = billAmount
        self.paymentOptions = paymentOptions
        self.billDueDate = billDueDate
        self.isBillSearch = isBillSearch
        self.categoryID = categoryID
        self.accountPayload = accountPayload
        self.category = category
    }
}
