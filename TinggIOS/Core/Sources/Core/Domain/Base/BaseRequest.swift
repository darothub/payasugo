//
//  BaseRequest.swift
//  
//
//  Created by Abdulrasaq on 19/07/2022.
//

import Foundation
import Alamofire
public class BaseRequest: ObservableObject, TinggApiServices {
    public init () {
        //Public init
    }
    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: TinggRequest,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(tinggRequest: tinggRequest)
            .execute { (result:Result<T, ApiError>) in
                onCompletion(result)
            }
    }
    public func makeRequest<T: BaseDTOprotocol>(
        urlPath: String,
        tinggRequest: TinggRequest? = nil,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        if tinggRequest != nil {
            request(urlPath: urlPath, tinggRequest: tinggRequest ?? .init())
                 .execute { (result:Result<T, ApiError>) in
                     onCompletion(result)
                 }
            return
        }
        request(urlPath: urlPath)
             .execute { (result:Result<T, ApiError>) in
                 onCompletion(result)
             }
    }
    
    func result<T: BaseDTOprotocol>(tinggRequest: TinggRequest) async throws -> Result<T, ApiError> {
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                print("Result \(result)")
                continuation.resume(returning: result)
            }
        }
    }
}


extension DataRequest {
    func execute<T: BaseDTOprotocol>(onCompletion: @escaping(Result<T, ApiError>) -> Void) {
        validate(statusCode: 200..<300)
        responseDecodable(of: T.self) { response in
            switch response.result {
            case .failure(let error):
                print("responseError \(error)")
                onCompletion(.failure(.networkError(error.localizedDescription)))
            case .success(let baseResponse):
                print("responseSuccess \(baseResponse)")
                onCompletion(.success(baseResponse))
            }
        }
    }
}
