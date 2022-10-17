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
public enum Screens {
    case launch, intro, home
}

public class NavigationUtils: ObservableObject {
    @Published public var screen = Screens.launch
    @Published public var current = Screens.launch
    @Published public var navigatePermission = true
    public init() {
        // Intentionally unimplemented...needed for modular accessibility
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
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

//Mark: 
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
