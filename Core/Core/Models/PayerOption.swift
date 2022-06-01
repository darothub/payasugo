//
//  PayerOption.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation

public class PayerOptions : Identifiable, Codable {
    public let clientId: String? = nil
    public let reference: String? = nil
    public let referenceLabel: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case clientId  = "PAYER_CLIENT_ID"
        case reference  = "PAYER_REFERENCE"
        case referenceLabel  = "REFERENCE_LABEL"
    }
}

   

