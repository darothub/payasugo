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
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .failure(let error):
                    print("response \(error)")
                    onCompletion(.failure(.networkError(error.localizedDescription)))
                case .success(let baseResponse):
                    onCompletion(.success(baseResponse))
                }
            }
    }
    public func makeRequest<T: BaseDTOprotocol>(
        urlPath: String? = nil,
        tinggRequest: TinggRequest,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        var apiRequest: DataRequest
        if urlPath == nil {
            apiRequest =  request(tinggRequest: tinggRequest)
        }
        else {
            guard let url = urlPath else {
                fatalError("Invalid url")
            }
            apiRequest = request(urlPath: url, tinggRequest: tinggRequest)
        }
        apiRequest
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .failure(let error):
                    print("response \(error)")
                    onCompletion(.failure(.networkError(error.localizedDescription)))
                case .success(let baseResponse):
                    onCompletion(.success(baseResponse))
                }
            }
    }
}
