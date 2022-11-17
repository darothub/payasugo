//
//  BaseRequest.swift
//  
//
//  Created by Abdulrasaq on 19/07/2022.
//

import Foundation
import Alamofire
/// Base request configuration for making Tingg API request
public class BaseRequest: ObservableObject, TinggApiServices {
    public init () {
        //Public init
    }
    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: TinggRequest,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        request(tinggRequest: tinggRequest)
            .validate(statusCode: 200..<400)
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
//            print("ResponseString \(response)")
        }
        responseJSON { response in
            print("ResponseJson \(response)")
        }
        responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                let dto = data as? BaseDTO
                if let statusCode = dto?.statusCode {
                    if statusCode > 201 {
                        onCompletion(.failure(.networkError(data.statusMessage)))
                        break
                    }
                }
                onCompletion(.success(data))
            case .failure(let error):
                onCompletion(.failure(.networkError(error.localizedDescription)))
            }
        }
    }
}

public func Log(_ logString: String?) {
    if logString?.isEmpty ?? false { return }
    NSLog("%@", logString!)
    Log(String(logString!.dropFirst(1024)))
}
