//
//  File.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
public enum SERVICEPARAMETERSDTO: Codable {
    case serviceparametersClass(SERVICEPARAMETERSClass)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(SERVICEPARAMETERSClass.self) {
            self = .serviceparametersClass(x)
            return
        }
        throw DecodingError.typeMismatch(SERVICEPARAMETERSDTO.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SERVICEPARAMETERSUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .serviceparametersClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    var toEntity: ServiceParametersEntity {
        var entity = ServiceParametersEntity()
        switch self {
        case .serviceparametersClass(let value):
            entity = value.toEntity
            return entity
        case .string(_):
            return ServiceParametersEntity()
        }
    }
}


// MARK: - SERVICEPARAMETERSClass
public struct SERVICEPARAMETERSClass: Codable {
    public let servicesData: [ServicesDataDTO]

    enum CodingKeys: String, CodingKey {
        case servicesData = "SERVICES_DATA"
    }
    var toEntity: ServiceParametersEntity {
        var entity = ServiceParametersEntity()
        let dtoList = servicesData.map {$0.toEntity}
        entity.servicesData.append(objectsIn: dtoList)
        return entity
    }
}

// MARK: - ServicesDataDTO
public struct ServicesDataDTO: Codable {
    public let serviceID: Int
    public let serviceName: String

    enum CodingKeys: String, CodingKey {
        case serviceID = "SERVICE_ID"
        case serviceName = "SERVICE_NAME"
    }
    var toEntity: ServicesDatumEntity {
        var entity = ServicesDatumEntity()
        entity.serviceName = self.serviceName
        entity.serviceID = self.serviceID
        return entity
    }
}
