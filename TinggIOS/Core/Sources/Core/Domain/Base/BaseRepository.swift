//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
//import Core

public class BaseRepository: TinggApiServices {
    public func request(tinggRequest: TinggRequest) -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public func getCountries() -> DataRequest {
        return AF.request(Utils.baseUrlStaging+"countries.php/", method: .get)
    }
    public init() {}
}
