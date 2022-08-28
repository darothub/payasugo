//
//  File.swift
//  
//
//  Created by Abdulrasaq on 27/08/2022.
//

import Foundation

public func makeDateFromString(validDateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    if validDateString.count > 10 {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    else {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    let date = dateFormatter.date(from: validDateString)!
    return date
}
