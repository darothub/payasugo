//
//  File.swift
//  
//
//  Created by Abdulrasaq on 02/07/2022.
//

import Foundation
public enum ApiError: Error {
    case networkError(String)
    
    public var localizedString: String {
        switch self {
        case .networkError(let string):
            return string
        }
    }
}
