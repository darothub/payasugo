//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

/// Base DTO protocol for Tingg API services
public protocol BaseDTOprotocol: Any, Decodable {
    var statusCode: Int {get}
    var statusMessage: String {get}
}

extension BaseDTOprotocol {
    public func log(message: String) {
        print("\(Self.self)->\n\(message)")
    }
}
