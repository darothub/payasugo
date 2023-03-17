//
//  YesOrNoEnum.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
public enum YesOrNoEnum: String, Codable {
    case no = "no"
    case yes = "yes"
    case NO = "NO"
    case YES = "YES"
    
    public var bool: Bool {
        switch self {
        case .NO, .no:
            return false
        case .YES, .yes:
            return true
        }
    }
}
