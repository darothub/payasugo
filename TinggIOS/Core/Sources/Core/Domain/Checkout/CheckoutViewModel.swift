//
//  File.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//

import Foundation
import SwiftUI
public class CheckoutViewModel: ObservableObject {
    @Published public var cm: CheckoutModel = .init()
    public init() {
        //
    }
    
    public func validatePhoneNumberByCountry(_ country: Country?, phoneNumber: String) -> Bool{
        if let regex = country?.countryMobileRegex {
            let result = validatePhoneNumber(with: regex, phoneNumber: phoneNumber)
            return result
        }
        return false
    }
    public func validateAmountByService(selectedService: MerchantService, amount: String) -> String {
        var result = ""
        let intAmount = convertStringToInt(value: amount)
        let minAmount = convertStringToInt(value: selectedService.minAmount)
        let maxAmount = convertStringToInt(value: selectedService.maxAmount)
        if amount.isEmpty {
            result = "Amount field can not be empty"
        }
        else if intAmount < minAmount || intAmount > maxAmount {
            result = "Amount should between \(minAmount) and \(maxAmount)"
        }
        return result
    }
}


public struct CheckoutModel: Hashable, Equatable {
    public var showCheckOutView: Bool = false
    public var service: MerchantService = sampleServices[0]
    public var amount: String = ""
    public var isSomeoneElsePaying: Bool = false
    public var selectedMerchantPayerName: String = ""
    public var accountNumber: String = ""
    public var currency: String = ""
    public var payer: MerchantPayer = .init()
    
    public init(showCheckOutView: Bool = false , service: MerchantService = sampleServices[0], amount: String = "", isSomeoneElsePaying: Bool = false, selectedMerchantPayerName: String = "", accountNumber: String = "", currency: String = "") {
        self.showCheckOutView = showCheckOutView
        self.service = service
        self.amount = amount
        self.isSomeoneElsePaying = isSomeoneElsePaying
        self.selectedMerchantPayerName = selectedMerchantPayerName
        self.accountNumber = accountNumber
        self.currency = currency
    }
}
