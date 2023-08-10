//
//  Utils.swift
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

public func decodeJSON<T: Decodable>(_ jsonString: String) throws -> T {
    guard let jsonData = jsonString.data(using: .utf8) else {
        throw NSError(domain: "JSONDecodeError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string."])
    }

    let decoder = JSONDecoder()
    let decodedObject = try decoder.decode(T.self, from: jsonData)
    return decodedObject
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
        phoneNumber.startIndex ..< phoneNumber.endIndex,
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
    if regex?.firstMatch(in: phoneNumber, options: [], range: range) != nil {
        return true
    } else {
        return false
    }
}

public func validateWithRegex(_ regex: String, value: String) -> Bool {
    let tester = NSPredicate(format: "SELF MATCHES %@", regex)
    return tester.evaluate(with: value)
}

public func checkStringForPatterns(inputString: String, pattern: String) -> Bool {
    do {
        let regex = try Regex(pattern)
        let match = inputString.firstMatch(of: regex)
        let result = match?.output.last?.value
        return result != nil
    } catch {
        print("Regex error: \(error)")
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
    public init(service: MerchantService, info: [Enrollment] = []) {
        self.service = service
        self.info = info
    }
}

public func handleServiceAndNominationFilter(service: MerchantService, nomination: [Enrollment]) -> BillDetails? {
    if service.presentmentType != "None" {
        let nominations: [Enrollment] = nomination.filter { enrollment in
            filterNominationInfoByHubServiceId(enrollment: enrollment, service: service)
        }
        let billDetails = BillDetails(service: service, info: nominations)
        return billDetails
    }
    return nil
}

public func filterNominationInfoByHubServiceId(enrollment: Enrollment, service: MerchantService) -> Bool {
    String(enrollment.hubServiceID) == service.hubServiceID
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

public func updatedTimeInUnits(time: Int) -> String {
    if time > (2 * 3599) {
        return "\(time / 3600) hours ago"
    } else if time > 3599 {
        return "\(time / 3600) hour ago"
    } else if time > 59 {
        return "\(time / 60) mins ago"
    } else {
        return "\(time) seconds ago"
    }
}

public func validatePhoneNumberByCountry(_ country: CountriesInfoDTO?, phoneNumber: String) -> Bool {
    if let regex = country?.countryMobileRegex {
        let result = validatePhoneNumber(with: regex, phoneNumber: phoneNumber)
        return result
    }
    return false
}

public func callSupport(phoneNumber: String) {
    let tel = "tel://"
    let formattedPhoneNumber = tel + phoneNumber
    guard let url = URL(string: formattedPhoneNumber) else { return }
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}

public func validateAmountByService(selectedService: MerchantService, amount: String) -> String {
    var result = ""
    let intAmount = convertStringToInt(value: amount.removeWhitespace())
    let minAmount = convertStringToInt(value: selectedService.minAmount)
    let maxAmount = convertStringToInt(value: selectedService.maxAmount)
    if amount.isEmpty {
        result = "Amount field can not be empty"
    } else if intAmount < minAmount || intAmount > maxAmount {
        result = "Amount should between \(minAmount) and \(maxAmount)"
    }
    return result
}

public func validateAmountByService(selectedService: MerchantService, amount: String) -> Bool {
    let intAmount = convertStringToInt(value: amount.removeWhitespace())
    let minAmount = convertStringToInt(value: selectedService.minAmount)
    let maxAmount = convertStringToInt(value: selectedService.maxAmount)
    if amount.isEmpty {
        return false
    } else if intAmount < minAmount || intAmount > maxAmount {
        return false
    }
    return true
}

extension Formatter {
    static func currencyFormat(currency: String = "KES") -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = currency
        return formatter
    }
}

extension Numeric {
    var currencyUS: String {
        Formatter.currencyFormat().string(for: self) ?? ""
    }
}

public func convertme(string: String, with currency: String) -> String {
    let string = string.filter("0123456789.".contains)
    let f = Formatter.currencyFormat(currency: currency)
    if let integer = Int(string) {
        f.maximumFractionDigits = 0
        return f.string(for: integer) ?? "0"
    }
    return Double(string)?.currencyUS ?? "0"
}

public struct CardDetails {
    public var imageUrl: String = ""
    public var cardNumber: String
    public var holderName: String = ""
    public var expDate: String = ""
    public var cvv: String = ""
    public var email: String = ""
    public var address: String = ""
    public var amount: String = ""
    public var suffix: String = ""
    public var prefix: String = ""
    public var checkout = false
    public var isActive = false
    public var cardType = ""
    public var merchantPayer: MerchantPayer = .init()
    public init(
        imageUrl: String = "",
        cardNumber: String = "",
        holderName: String = "",
        expDate: String = "",
        cvv: String = "",
        email: String = "",
        address: String = "",
        amount: String = ""
    ) {
        self.imageUrl = imageUrl
        self.cardNumber = cardNumber
        self.holderName = holderName
        self.expDate = expDate
        self.cvv = cvv
        self.email = email
        self.address = address
        self.amount = amount
        suffix = self.cardNumber.suffix(4).description
        prefix = self.cardNumber.prefix(4).description
       
    }


    public mutating func getEncryptedAlias() -> String {
        suffix = self.cardNumber.suffix(4).description
        return CreditCardUtil.encrypt(data: suffix)
    }
    public func getEncryptedExpDate() -> String {
        CreditCardUtil.encrypt(data: self.expDate)
    }
    public mutating func getEncryptedPrefix() -> String {
        prefix = self.cardNumber.prefix(4).description
        return CreditCardUtil.encrypt(data: prefix)
    }
    public func getMaskedPan() -> String {
        return "**** **** **** \(cardNumber)"
    }
    public func getCreditCardName() -> String {
        switch cardType {
        case "001":
            return "visa"
        case "002":
            return "mastercard"
        case "003":
            return "amex"
        case "005":
            return "DINERS"
        case "004":
            return "discover"
        case "007":
            return "jcb"
        case "006":
            return "CarteBlanche"
        case "014":
            return "EnRoute"
        default:
            return ""
        }
    }
}

extension View {
    public func throwError(message: String) -> Never {
        return fatalError("\(Self.self) -> \(message)")
    }

    public func log(message: Any) {
        print("\(Self.self) -> \(message)")
    }
}

public func formatNumber(_ numberString: String) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal

    if let number = numberFormatter.number(from: numberString) {
        let formattedString = numberFormatter.string(from: number) ?? numberString
        return formattedString
    } else {
        return numberString
    }
}

public func formatNumber(_ number: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal

    if let formattedString = numberFormatter.string(from: NSNumber(value: number)) {
        return formattedString
    } else {
        return String(number)
    }
}
