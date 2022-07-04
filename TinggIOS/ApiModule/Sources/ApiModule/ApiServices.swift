//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/06/2022.
//
import Alamofire
import Foundation
public protocol ApiServices {
    func getCountries() -> DataRequest
}
