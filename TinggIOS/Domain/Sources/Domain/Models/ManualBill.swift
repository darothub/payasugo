//
//  ManualBill.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - ManualBil
public class ManualBill: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted public var manualBillID:String? = ""
    @Persisted public var merchantAccountNumber:String? = ""
    @Persisted public var merchantName:String? = ""
    @Persisted public var billReminderFrequency: String? = ""
    @Persisted public var billAmount: String? = ""
    @Persisted public var paymentOptions = RealmSwift.List<PayerOptions>()
    @Persisted public var billDueDate:String? = ""
    @Persisted public var isBillSearch:String? = ""
    @Persisted public var categoryID:String? = ""
    @Persisted public var accountPayload: String? = ""
    @Persisted public var category: Category? = nil

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

//    init(
//        manualBillID: String?, merchantAccountNumber: String?, merchantName: String?,
//        billReminderFrequency: String?, billAmount: String?, paymentOptions: RealmSwift.List<PayerOptions>,
//        billDueDate: String?, isBillSearch: String?, categoryID: String?,
//        accountPayload: String?, category: Category?
//    ) {
//        self.manualBillID = manualBillID
//        self.merchantAccountNumber = merchantAccountNumber
//        self.merchantName = merchantName
//        self.billReminderFrequency = billReminderFrequency
//        self.billAmount = billAmount
//        self.paymentOptions = paymentOptions
//        self.billDueDate = billDueDate
//        self.isBillSearch = isBillSearch
//        self.categoryID = categoryID
//        self.accountPayload = accountPayload
//        self.category = category
//    }
}
