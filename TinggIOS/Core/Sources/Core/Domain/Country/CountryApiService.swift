//
//  File.swift
//  
//
//  Created by Abdulrasaq on 09/08/2022.
//
import Alamofire
import Foundation
extension TinggApiServices {
    public func getCountries() -> DataRequest {
        return AF.request(Utils.baseUrlStaging+"countries.php/", method: .get)
    }
}
