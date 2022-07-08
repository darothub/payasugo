//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
import Core
import Foundation
import UIKit
public class CountryRepository: CountryApiServices {
    public func getActivationCode(activationCodeRequest: TinggRequest) -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: activationCodeRequest, encoder: JSONParameterEncoder.default)
    }
    public func confirmActivationCode(activationCodeRequest: TinggRequest) -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: activationCodeRequest, encoder: JSONParameterEncoder.default)
    }
    public func getCountries() -> DataRequest {
        return AF.request(Utils.baseUrlStaging+"countries.php/", method: .get)
    }
    public init() {}
}
