//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

struct CountryDTO: BaseDTO, Codable {
    typealias Model = [Country]
    var statusCode: Int
    var statusMessage: String
    var data: [Country]
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case data = "COUNTRIES_INFO"
    }
}
