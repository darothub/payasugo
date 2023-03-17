//
//  FORMPARAMETERSDTO.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation

public enum FORMPARAMETERSDTO: Codable {
    case formparametersClass(FORMPARAMETERSClass)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(FORMPARAMETERSClass.self) {
            self = .formparametersClass(x)
            return
        }
        throw DecodingError.typeMismatch(FORMPARAMETERSDTO.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for FORMPARAMETERSUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .formparametersClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    public var toEntity: FORMPARAMETERSClassEntity {
        var entity = FORMPARAMETERSClassEntity()
        switch self {
        case .formparametersClass(let values):
            let list = values.formParameters.map { $0.toEntity}
            entity.formParameters.append(objectsIn: list)
            return entity
        case .string(_):
            return entity
        }
      
    }
}

// MARK: - FORMPARAMETERSClass
public struct FORMPARAMETERSClass: Codable {
    public let formParameters: [FormParameter]
    public let name, label: String?

    enum CodingKeys: String, CodingKey {
        case formParameters = "FORM_PARAMETERS"
        case name = "NAME"
        case label = "LABEL"
    }
    var toEntity : FORMPARAMETERSClassEntity {
        let entity = FORMPARAMETERSClassEntity()
        entity.name = self.name
        entity.label = self.label
        let fps = formParameters.map {$0.toEntity}
        entity.formParameters.append(objectsIn: fps)
        return entity
    }
}
