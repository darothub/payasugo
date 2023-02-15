//
//  File.swift
//  
//
//  Created by Abdulrasaq on 05/07/2022.
//
import Foundation
/// Base DTO struct for Tingg API services
public struct BaseDTO: BaseDTOprotocol {
    public var statusCode: Int
    public var statusMessage: String
    public init(statusCode: Int, statusMessage: String) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
    }
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
    }
}
