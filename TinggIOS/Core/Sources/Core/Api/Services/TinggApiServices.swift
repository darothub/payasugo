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
    func result<T: Decodable>(_ parameters: [String:String]) async throws -> T
    func makeRequest<T: Decodable>(
        parameters: [String:String],
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    )
}

extension TinggApiServices {
   
    public func request(tinggRequest: RequestMap) -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: tinggRequest.dict, encoding: JSONEncoding.default)
    }
    public func request(url: String, method: HTTPMethod, parameters: [String:Any]) -> DataRequest {
        return AF.request(url, method: method,
                          parameters: parameters, encoding: JSONEncoding.default)
    }
    public func request(parameters: [String:String]) -> DataRequest {
        return AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, interceptor: headerInterceptor)
    }
    public func request(urlPath: String, tinggRequest: RequestMap) -> DataRequest {
        return AF.request(Utils.baseUrlStaging+urlPath, method: .post,
                          parameters: tinggRequest.dict, encoding: JSONEncoding.prettyPrinted)
    }
    public func request(urlPath: String) -> DataRequest {
        return AF.request(Utils.baseUrlStaging+urlPath, method: .get)
    }
    
    public func basicAuthRequest(url: String, method: HTTPMethod, headers: HTTPHeaders?) -> DataRequest {
        return AF.request(url, method: method, headers: headers)
    }
    public func makeBasicAuthRequest<T: Decodable>(
        url: String, method: HTTPMethod, headers: HTTPHeaders?,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        basicAuthRequest(url: url, method: .post, headers: headers)
            .execute { (result:Result<T, ApiError>) in
                onCompletion(result)
            }
    }
    public func makeRequest<T: Decodable>(
        url: String, method: HTTPMethod, parameters: [String:Any],
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(url: url, method: method, parameters: parameters)
            .execute { (result:Result<T, ApiError>) in
                onCompletion(result)
            }
             
    }
    public func makeRequest<T: Decodable>(
        parameters: [String:String],
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(parameters: parameters)
            .execute { (result:Result<T, ApiError>) in
                onCompletion(result)
            }
             
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
    
    public func makeRequest<T: BaseDTOprotocol>(
        urlPath: String,
        tinggRequest: RequestMap,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(urlPath: urlPath, tinggRequest: tinggRequest)
            .validate(statusCode: 200..<300)
            .execute { (result:Result<T, ApiError>) in
                onCompletion(result)
            }
    }
    
    public func result<T: BaseDTOprotocol>(tinggRequest: RequestMap) async throws -> T {
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
    public func result<T: BaseDTOprotocol>(urlPath: String, tinggRequest: RequestMap) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(urlPath: urlPath, tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let data):
                    continuation.resume(returning: data)
                }
            }
        }
    }
    private var url: String {
        AppStorageManager.getProcessRequestUrl()
    }
    private var headerInterceptor: RequestInterceptor {
        CustomRequestInterceptor()
    }
}




