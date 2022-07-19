//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

public protocol BaseDTOprotocol: Decodable {
    var statusCode: Int {get}
    var statusMessage: String {get}
}
