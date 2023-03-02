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
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public func request(tinggRequest: RequestMap) -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: tinggRequest.dict, encoding: JSONEncoding.prettyPrinted)
    }
    public func request(urlPath: String, tinggRequest: TinggRequest) -> DataRequest {
        return AF.request(Utils.baseUrlStaging+urlPath, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public func request(urlPath: String, tinggRequest: RequestMap) -> DataRequest {
        return AF.request(Utils.baseUrlStaging+urlPath, method: .post,
                          parameters: tinggRequest.dict, encoding: JSONEncoding.prettyPrinted)
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
    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: RequestMap,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(tinggRequest: tinggRequest)
            .validate(statusCode: 200..<300)
            .execute { (result:Result<T, ApiError>) in
                onCompletion(result)
            }
    }
    
    public func result<T: BaseDTOprotocol>(tinggRequest: RequestMap) async throws -> T {
        print("TinggRequestApi \(tinggRequest)")
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let data):
                    continuation.resume(returning: data)
                }
            }
        }
    }
}




