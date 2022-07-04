//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
import Foundation
public protocol CountryApiServices {
    func getCountries() -> DataRequest
}
