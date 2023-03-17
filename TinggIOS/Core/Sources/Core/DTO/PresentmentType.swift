//
//  PresentmentType.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
public enum PresentmentType: String, Codable {
    case empty = ""
    case hasNone = "hasNone"
    case hasPostpaid = "hasPostpaid"
    case hasPresentment = "hasPresentment"
    case hasValidation = "hasValidation"
}
