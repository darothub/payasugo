//
//  File.swift
//  
//
//  Created by Abdulrasaq on 27/08/2022.
//

import Foundation

extension Date {
    
    /// An operator to compute date difference
    /// - Parameters:
    ///   - lhs: an instance of the latest date
    ///   - rhs: an instance of the old date
    /// - Returns: the difference in Time interval
    public static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    /// For formatting a date
    /// ```swift
    ///let date = Date()
    ///date.formatted(with: "EE, dd MM yyyy")
    /// ```
    /// - Parameter formatString: format string pattern
    /// - Returns: a String
    public func formatted(with formatString: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = formatString
           return dateFormatter.string(from: self)
    }
}

/// Converts a date string to a date object
/// ```swift
/// let dateString = "2022-10-28 00:00:00"
/// let date = ``makeDateFromString(validDateString:dateString)``
/// ```
/// - Parameter validDateString: date string
/// - Returns: a Date
public func makeDateFromString(validDateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    if validDateString.count > 10 {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    else {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    let date = dateFormatter.date(from: validDateString)
    guard let date = date else {
       return Date()
    }
    return date
}

extension TimeInterval {

    public var seconds: Int {
        return Int(self.rounded())
    }

    public var milliseconds: Int {
        return Int(self * 1_000)
    }
    public var minute: Int {
        return Int(self/60)
    }
    
    public var hour: Int {
        return Int(self/(60*60))
    }
    
    public var day: Int {
        return Int(self/(24*60*60))
    }
}
