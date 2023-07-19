//
//  DTOandObjectWrapper.swift
//  
//
//  Created by Abdulrasaq on 15/06/2023.
//

import Foundation
import RealmSwift

public struct DTOandObjectWrapper<D, O> where D: Codable, O: Object {
    public var dtos: [D]
    public var objs: [O]
    public init(dtos: [D], objs: [O]) {
        self.dtos = dtos
        self.objs = objs
    }
}

public class ObjectMapper {
   
   public static func map<U: Codable, V: Codable>(_ object: U) -> V? {
        do {
            let encoder = JSONEncoder()
            let encodedObject = try encoder.encode(object)
            let decoder = JSONDecoder()
            let dto = try decoder.decode(V.self, from: encodedObject)
            let jsonData = try JSONEncoder().encode(dto)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return dto
        } catch {
            print("Error converting object to JSON: \(error)")
            return nil
        }
    }
}


    
    

