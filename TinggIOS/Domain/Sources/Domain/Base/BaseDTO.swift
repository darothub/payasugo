//
//  File.swift
//  
//
//  Created by Abdulrasaq on 05/07/2022.
//

import Foundation
public struct BaseDTO: BaseDTOprotocol, Codable {
    var statusCode: Int
    var statusMessage: String
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
    }
}
