//
//  BaseRequest.swift
//  
//
//  Created by Abdulrasaq on 19/07/2022.
//

import Foundation
import Alamofire
/// Base request configuration for making Tingg API request
public class BaseRequest: TinggApiServices {
    public init () {
        //Public init
    }
    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: TinggRequest,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(tinggRequest: tinggRequest)
            .validate(statusCode: 200..<300)
            .execute { (result:Result<T, ApiError>) in
                onCompletion(result)
            }
    }
    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: RequestMap,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        print("Tinggrequest \(tinggRequest)")
        request(tinggRequest: tinggRequest)
            .validate(statusCode: 200..<300)
            .execute { (result:Result<T, ApiError>) in
                onCompletion(result)
            }
    }
    public func makeRequest<T: BaseDTOprotocol>(
        urlPath: String,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(urlPath: urlPath)
            .validate(statusCode: 200..<400)
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
            .validate(statusCode: 200..<400)
             .execute { (result:Result<T, ApiError>) in
                 onCompletion(result)
             }
    }
    func result<T: BaseDTOprotocol>(urlPath: String, tinggRequest: RequestMap) async throws -> Result<T, ApiError> {
        print("Tinggrequest \(tinggRequest)")
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(urlPath: urlPath, tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }
    func result<T: BaseDTOprotocol>(tinggRequest: TinggRequest) async throws -> Result<T, ApiError> {
        print("Tinggrequest \(tinggRequest)")
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }
    func result<T: BaseDTOprotocol>(tinggRequest: RequestMap) async throws -> Result<T, ApiError> {
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }
}


extension DataRequest {
    fileprivate func handleSuccess<T: BaseDTOprotocol>(_ decoder: JSONDecoder, _ data: String, _ onCompletion: @escaping(Result<T, ApiError>) -> Void) {
        do {
            let result = try decoder.decode(BaseDTO.self, from: data.data(using: .utf8)!)
            if result.statusCode > 202 {
                print("Result202 above \(result)")
                onCompletion(.failure(.networkError(result.statusMessage)))
            } else {
                let result = try decoder.decode(T.self, from: data.data(using: .utf8)!)
                print("Result200 \(result)")
                onCompletion(.success(result))
            }
        } catch {
            print("Error200 \(error)")
            onCompletion(.failure(.networkError(error.localizedDescription)))
        }
    }
    
    func execute<T: BaseDTOprotocol>(onCompletion: @escaping(Result<T, ApiError>) -> Void) {
        responseString { response in
            Log.d(message: "\(response.result)")
            let decoder = JSONDecoder()
            switch response.result {
                
            case .success(let data):
                if let httpResponse = response.response,  httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    self.handleSuccess(decoder, data, onCompletion)
                }
            case .failure(let error):
                print("FailureError \(error)")
                onCompletion(.failure(.networkError(error.localizedDescription)))
            }
        }
    }
}


