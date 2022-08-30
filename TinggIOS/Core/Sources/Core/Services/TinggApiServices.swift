//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
import Foundation
import SwiftUI
public protocol TinggApiServices {
    func request(tinggRequest: TinggRequest) -> DataRequest
}

extension TinggApiServices {
    public func request(tinggRequest: TinggRequest) -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public func request(urlPath: String, tinggRequest: TinggRequest) -> DataRequest {
        return AF.request(Utils.baseUrlStaging+urlPath, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public func request(urlPath: String) -> DataRequest {
        return AF.request(Utils.baseUrlStaging+urlPath, method: .get)
    }
}

