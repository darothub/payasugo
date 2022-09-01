//
//  File.swift
//  
//
//  Created by Abdulrasaq on 27/08/2022.
//

import Foundation

extension Date {
    public static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

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
        fatalError("Date string \(validDateString) is invalid")
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
