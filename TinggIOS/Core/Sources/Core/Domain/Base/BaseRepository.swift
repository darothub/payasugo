//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
public class BaseRepository: TinggApiServices {
    public func request(tinggRequest: TinggRequest) -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public init() {
        // Intentionally unimplemented...needed for modular accessibility
    }
}