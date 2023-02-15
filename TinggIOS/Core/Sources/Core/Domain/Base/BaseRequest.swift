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
        request(tinggRequest: tinggRequest.dict)
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
    
    func result<T: BaseDTOprotocol>(tinggRequest: TinggRequest) async throws -> Result<T, ApiError> {
        print("TinggRequest \(tinggRequest)")
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }
    func result<T: BaseDTOprotocol>(tinggRequest: RequestMap) async throws -> Result<T, ApiError> {
        print("TinggRequest \(tinggRequest)")
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }
}


extension DataRequest {
    func execute<T: BaseDTOprotocol>(onCompletion: @escaping(Result<T, ApiError>) -> Void) {
        responseString { response in
            let decoder = JSONDecoder()
            switch response.result {
                
            case .success(let data):
                if let httpResponse = response.response {
                    switch httpResponse.statusCode {
                    case 200..<300:
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
                    default:
                        print("Response below 300 \(response)")
                    }
                }
            case .failure(let error):
                print("FailureError \(error)")
                onCompletion(.failure(.networkError(error.localizedDescription)))
            }
        }
        responseJSON { response in
            print("ResponseJson \(response.result)")
           
        }
        
//        responseDecodable(of: T.self) { response in
//            switch response.result {
//            case .success(let data):
//                let dto = data as? BaseDTO
//                if let statusCode = dto?.statusCode {
//                    if statusCode > 201 {
//                        onCompletion(.failure(.networkError(data.statusMessage)))
//                        break
//                    }
//                }
//                onCompletion(.success(data))
//            case .failure(let error):
//                print("Error \(error)")
//                onCompletion(.failure(.networkError(error.localizedDescription)))
//            }
//        }
    }
}


