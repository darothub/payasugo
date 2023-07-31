//
//  File.swift
//  
//
//  Created by Abdulrasaq on 02/07/2022.
//

import Foundation
/// Enum type for capturing Remote error
public enum ApiError: Error {
    case networkError(String)
    public static var serverErrorString = "Server error, please try again"
    
    public var localizedString: String {
        switch self {
        case .networkError(let string):
            return string
        }
    }
}
