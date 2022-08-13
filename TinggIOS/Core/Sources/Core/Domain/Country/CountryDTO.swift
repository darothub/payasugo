//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

public struct CountryDTO: BaseDTOprotocol, Codable {
    public var statusCode: Int = 0
    public var statusMessage: String = ""
    public var data: [Country] = []
    public init() {
        // Intentionally unimplemented...needed for modular accessibility
    }
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case data = "COUNTRIES_INFO"
    }
}
