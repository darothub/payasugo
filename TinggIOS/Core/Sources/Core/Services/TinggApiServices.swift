//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
import Foundation
import SwiftUI
/// A protocol/interface for Tingg API services
public protocol TinggApiServices {
    func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: TinggRequest,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    )
}

extension TinggApiServices {
    public func request(tinggRequest: TinggRequest) -> DataRequest {
        print("Request \(tinggRequest)")
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public func request(urlPath: String, tinggRequest: TinggRequest) -> DataRequest {
        print("Request2 \(tinggRequest)")
        return AF.request(Utils.baseUrlStaging+urlPath, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public func request(urlPath: String) -> DataRequest {
        return AF.request(Utils.baseUrlStaging+urlPath, method: .get)
    }
    public func makeRequest<T: BaseDTOprotocol>(
        urlPath: String,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(urlPath: urlPath)
             .execute { (result:Result<T, ApiError>) in
                 onCompletion(result)
             }
    }
}

