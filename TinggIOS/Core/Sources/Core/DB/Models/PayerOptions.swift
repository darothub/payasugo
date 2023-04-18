//
//  PayerOption.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
public class PayerOptions: EmbeddedObject, ObjectKeyIdentifiable, Codable {
    @Persisted public var clientId: String? = nil
    @Persisted public var reference: String? = nil
    @Persisted public var referenceLabel: String? = nil
    enum CodingKeys: String, CodingKey {
        case clientId  = "PAYER_CLIENT_ID"
        case reference  = "PAYER_REFERENCE"
        case referenceLabel  = "REFERENCE_LABEL"
    }
}
