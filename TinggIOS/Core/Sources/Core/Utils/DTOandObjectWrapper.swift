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
