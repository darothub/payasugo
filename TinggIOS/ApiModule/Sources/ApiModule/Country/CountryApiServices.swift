//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
import Core
import Foundation

public protocol CountryApiServices {
    func getCountries() -> DataRequest
    func getActivationCode(activationCodeRequest: TinggRequest) -> DataRequest
}
