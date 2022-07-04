//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

protocol BaseDTO {
    associatedtype Model
    var statusCode: Int {get}
    var statusMessage: String {get}
    var data: Model {get}
}
