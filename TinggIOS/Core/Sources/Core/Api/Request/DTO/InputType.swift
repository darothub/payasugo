//
//  InputType.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
public enum InputType: String, Codable {
    case empty = ""
    case numeric = "numeric"
    case phone = "phone"
    case text = "text"
}
