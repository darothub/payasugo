//
//  Date.swift
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
    /// An operator to compute date greaterthan
    /// - Parameters:
    ///   - lhs: an instance of the latest date
    ///   - rhs: an instance of the old date
    /// - Returns: the difference in Time interval
    
    public static func gt (lhs: Date, rhs: Date) -> Bool {
        return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
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
    public static let mmddyyFormat: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateStyle = .long
          return formatter
    }()
    
    public func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Define the desired date format
        let dateString = dateFormatter.string(from: self)

       return dateString
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
    var dateString = validDateString
    if validDateString.contains(".") {
        dateString = String(validDateString.split(separator: ".").first!)
    }
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    if dateString.count > 10 {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    else {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    let date = dateFormatter.date(from: dateString)
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
    
    public var year: Int {
        return Int(self/(24*60*60*365))
    }
}
