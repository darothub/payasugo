//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Foundation
import SwiftUI
public enum Utils {
    public static let baseUrlStaging = "https://kartana.tingg.africa/pci/mula_ke/api/v1/"
    public static let defaultNetworkServiceId = "DEFAULT_NETWORK_SERVICE_ID"
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    public func isNotEmpty() -> Bool {
        return !self.isEmpty
    }
}

public func addDaysToCurrentDate(numOfDays: Int) -> Date {
    let currentDate = Date()
    var dateComponent = DateComponents()
    dateComponent.day = numOfDays
    let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
    return futureDate!
}

public func formatDateToString(date: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let now = df.string(from: date)
    return now
}

public func validatePhoneNumberWith(regex: String, phoneNumber: String) -> [NSTextCheckingResult]? {
    let phoneRegex = try? NSRegularExpression(
        pattern: regex,
        options: []
    )
    let sourceRange = NSRange(
        phoneNumber.startIndex..<phoneNumber.endIndex,
        in: phoneNumber
    )
    let result = phoneRegex?.matches(
        in: phoneNumber,
        options: [],
        range: sourceRange
    )
    return result
}

public func validatePhoneNumber(with regex: String, phoneNumber: String) -> Bool {
    let range = NSRange(location: 0, length: phoneNumber.count)
    let regex = try? NSRegularExpression(pattern: regex)
    if regex?.firstMatch(in: phoneNumber, options: [], range: range) != nil{
        return true
    }else{
        return false
    }
}


public func validatePhoneNumberIsNotEmpty(number: String) -> Bool {
    if number.isEmpty {
        return false
    }
    return true
}
// MARK: Optional Extension
extension Optional: RawRepresentable where Wrapped: Codable {
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let json = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return json
    }

    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let value = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        self = value
    }
}

public struct TitleAndListItem: Hashable {
    public let title: String
    public let services: [MerchantService]
    public init(title: String, services: [MerchantService]) {
        self.title = title
        self.services = services
    }
}

public struct BillDetails: Hashable {
    public let service: MerchantService
    public let info: [Enrollment]
    public init(service: MerchantService, info: [Enrollment]) {
        self.service = service
        self.info = info
    }
}

public func computeProfileInfo(service: MerchantService, accountNumber: String) -> String {
    "\(service.receiverSourceAddress)|\(accountNumber)|\(service.serviceName)|\(service.hubClientID)|\(service.hubServiceID)|\(service.categoryID)||||||||"
}

public func convertStringToInt(value: String) -> Int {
    let floatValue = Float(value)
    let intAmount = Int(floatValue ?? 0.0)
    return intAmount
}

public func checkLength(_ newValue: String, length: Int) -> String {
    var number = String(newValue)
    if newValue.count > length {
        number = String(newValue.prefix(length))
    }
    return number
}

extension String {
    public func applyPattern(pattern: String = "#### #### #### ####", replacmentCharacter: Character = "#") -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    public func applyCVVPattern(pattern: String = "##/##", replacmentCharacter: Character = "#") -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    public func convertStringToInt() -> Int {
        let floatValue = Float(self)
        let intAmount = Int(floatValue ?? 0.0)
        return intAmount
    }
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
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


public protocol CheckoutProtocol {
    var showCheckOutView: Bool { get set }
    var dcddm: DebitCardDropDownModel { get set }
    var showCardOptions: Bool { get set }
    var isSomeoneElsePaying: Bool { get set }
    var service: MerchantService { get set }
    var cardDetails: CardDetails { get set }
}

public struct CardDetails {
    public var cardNumber: String = ""
    public var holderName: String = ""
    public var expDate: String = ""
    public var cvv: String = ""
    public var email: String = ""
    public var address: String = ""
    public var encryptedExpDate: String = ""
    public var encryptedSuffix: String = ""
    public var encryptedPrefix: String = ""
    public var amount: String = ""
 
    
    public init(cardNumber: String = "", holderName: String = "", expDate: String = "", cvv: String = "",  email: String = "",address: String = "", amount: String = "") {
        self.cardNumber = cardNumber
        self.holderName = holderName
        self.expDate = expDate
        self.cvv = cvv
        self.email = email
        self.address = address
        self.amount = amount
    }
    
    public mutating func encryptdata() -> Self {
        let suffix = String(self.cardNumber.suffix(4))
        let prefix = String(self.cardNumber.prefix(4))
        self.encryptedExpDate = CreditCardUtil.encrypt(data: self.expDate)
        self.encryptedSuffix = CreditCardUtil.encrypt(data: suffix)
        self.encryptedPrefix = CreditCardUtil.encrypt(data: prefix)
        return self
    }

}

public protocol BuyAirtimeProtocol {
    var suggestedAmountModel: SuggestedAmountModel { get set }
    var favouriteEnrollmentListModel: FavouriteEnrollmentModel { get set }
    var providersListModel: ProvidersListModel { get set }
    var service: MerchantService { get set }
}

public protocol ServiceDialogProtocol {
    var servicesDialogModel: ServicesDialogModel { get set }
}


extension View {
    public func throwError(message: String) -> Never {
        return fatalError("\(Self.self) -> \(message)")
    }
    public func log(message: String) {
        print("\(Self.self) -> \(message)")
    }
}




