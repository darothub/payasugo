//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
import Foundation
public class CountryRepository: CountryApiServices {
    public func getCountries() -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .get)
    }
    public init() {}
}
